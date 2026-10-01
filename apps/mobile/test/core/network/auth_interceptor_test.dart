import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nozie_mobile/core/network/api_client.dart';
import 'package:nozie_mobile/core/network/api_exception.dart';
import 'package:nozie_mobile/core/storage/token_storage.dart';

class _MemoryTokens extends TokenStorage {
  String? access;
  String? refresh;

  @override
  Future<String?> readAccessToken() async => access;
  @override
  Future<String?> readRefreshToken() async => refresh;
  @override
  Future<void> save({required String accessToken, required String refreshToken}) async {
    access = accessToken;
    refresh = refreshToken;
  }

  @override
  Future<void> clear() async {
    access = null;
    refresh = null;
  }
}

/// Serves canned responses and records every request.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.handler);

  final ResponseBody Function(RequestOptions o) handler;
  final List<RequestOptions> calls = [];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    calls.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int status, Map<String, dynamic> body) => ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
    );

Map<String, dynamic> _ok(Object? data) => {'status': 200, 'message': 'OK', 'data': data};

void main() {
  late _MemoryTokens tokens;
  late int expired;

  setUp(() {
    tokens = _MemoryTokens()
      ..access = 'old-access'
      ..refresh = 'old-refresh';
    expired = 0;
  });

  Dio client(_FakeAdapter adapter) {
    return buildApiClient(
      tokens: tokens,
      onSessionExpired: () => expired++,
      baseUrl: 'http://test',
      adapter: adapter,
    );
  }

  test('attaches bearer token', () async {
    final adapter = _FakeAdapter((_) => _json(200, _ok({})));
    await client(adapter).get<dynamic>('/users/me');
    expect(adapter.calls.single.headers['Authorization'], 'Bearer old-access');
  });

  test('401 triggers one refresh, then replays with the new token', () async {
    final adapter = _FakeAdapter((o) {
      if (o.path == '/auth/refresh') {
        return _json(200, _ok({'accessToken': 'new-access', 'refreshToken': 'new-refresh'}));
      }
      return o.headers['Authorization'] == 'Bearer new-access'
          ? _json(200, _ok({'ok': true}))
          : _json(401, {'status': 401, 'message': 'x', 'data': {'code': 'UNAUTHORIZED'}});
    });

    final res = await client(adapter).get<dynamic>('/users/me');

    expect((res.data as Map)['data']['ok'], true);
    expect(tokens.refresh, 'new-refresh');
    expect(adapter.calls.where((c) => c.path == '/auth/refresh').length, 1);
    expect(expired, 0);
  });

  test('parallel 401s share a single refresh', () async {
    final adapter = _FakeAdapter((o) {
      if (o.path == '/auth/refresh') {
        return _json(200, _ok({'accessToken': 'new-access', 'refreshToken': 'new-refresh'}));
      }
      return o.headers['Authorization'] == 'Bearer new-access'
          ? _json(200, _ok({}))
          : _json(401, {'status': 401, 'message': 'x', 'data': {'code': 'UNAUTHORIZED'}});
    });
    final dio = client(adapter);

    await Future.wait([dio.get<dynamic>('/a'), dio.get<dynamic>('/b'), dio.get<dynamic>('/c')]);

    expect(adapter.calls.where((c) => c.path == '/auth/refresh').length, 1);
  });

  test('rejected refresh clears tokens and ends the session', () async {
    final adapter = _FakeAdapter((o) => _json(401, {'status': 401, 'message': 'x', 'data': {'code': 'INVALID_TOKEN'}}));

    await expectLater(client(adapter).get<dynamic>('/users/me'), throwsA(isA<DioException>()));

    expect(expired, 1);
    expect(tokens.access, isNull);
    expect(tokens.refresh, isNull);
  });

  test('auth endpoints never trigger a refresh loop', () async {
    final adapter = _FakeAdapter((o) => _json(401, {'status': 401, 'message': 'Invalid email or password', 'data': {'code': 'INVALID_CREDENTIALS'}}));

    await expectLater(
      client(adapter).post<dynamic>('/auth/login', data: {}),
      throwsA(isA<DioException>()),
    );

    expect(adapter.calls.length, 1);
    expect(expired, 0);
  });

  test('network failure during refresh keeps the session', () async {
    final adapter = _FakeAdapter((o) {
      if (o.path == '/auth/refresh') {
        throw DioException(requestOptions: o, type: DioExceptionType.connectionError);
      }
      return _json(401, {'status': 401, 'message': 'x', 'data': {'code': 'UNAUTHORIZED'}});
    });

    await expectLater(client(adapter).get<dynamic>('/users/me'), throwsA(isA<DioException>()));

    expect(expired, 0);
    expect(tokens.refresh, 'old-refresh');
  });

  test('ApiException exposes the server error code and field violations', () {
    final e = ApiException.fromDio(DioException(
      requestOptions: RequestOptions(path: '/x'),
      response: Response(
        requestOptions: RequestOptions(path: '/x'),
        statusCode: 400,
        data: {
          'status': 400,
          'message': 'Request validation failed',
          'data': {
            'code': 'VALIDATION_FAILED',
            'violations': [{'field': 'password', 'message': 'too short'}],
          },
        },
      ),
    ));
    expect(e.code, 'VALIDATION_FAILED');
    expect(e.fieldErrors['password'], 'too short');
    expect(e.statusCode, 400);
  });
}
