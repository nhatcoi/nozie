import 'dart:async';

import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

/// Adds the bearer token and, on a 401, refreshes once (single-flight) and replays the request.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.dio,
    required this.tokens,
    required this.refreshDio,
    required this.onSessionExpired,
  });

  final Dio dio;
  final TokenStorage tokens;

  /// A bare Dio (no interceptors) used only for `/auth/refresh`, so a refresh never recurses.
  final Dio refreshDio;
  final void Function() onSessionExpired;

  static const _retriedKey = 'auth_retried';

  Future<bool>? _refreshing;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokens.readAccessToken();
    if (token != null && token.isNotEmpty && !options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;
    final isAuthCall = request.path.startsWith('/auth/');
    if (err.response?.statusCode != 401 || isAuthCall || request.extra[_retriedKey] == true) {
      return handler.next(err);
    }

    final refreshed = await (_refreshing ??= _refresh().whenComplete(() => _refreshing = null));
    if (!refreshed) {
      return handler.next(err);
    }
    try {
      request.extra[_retriedKey] = true;
      request.headers.remove('Authorization');
      handler.resolve(await dio.fetch<dynamic>(request));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<bool> _refresh() async {
    final refreshToken = await tokens.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      onSessionExpired();
      return false;
    }
    try {
      final res = await refreshDio.post<dynamic>('/auth/refresh', data: {'refreshToken': refreshToken});
      final data = (res.data as Map)['data'] as Map;
      await tokens.save(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
      return true;
    } on DioException catch (e) {
      // Only a definitive rejection ends the session; a flaky network must not log the user out.
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        await tokens.clear();
        onSessionExpired();
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
