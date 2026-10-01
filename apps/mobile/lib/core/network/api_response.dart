import 'package:dio/dio.dart';

import 'package:nozie_mobile/core/network/api_exception.dart';

/// Unwraps the server envelope `{ status, message, data }`.
extension ApiResponseX on Response<dynamic> {
  /// The `data` payload (any JSON type). Throws [ApiException] if the body is not an envelope.
  dynamic get payload {
    final body = this.data;
    if (body is Map && body.containsKey('status')) return body['data'];
    throw ApiException(code: 'UNKNOWN', message: 'Unexpected response format', statusCode: statusCode);
  }

  Map<String, dynamic> get payloadMap => Map<String, dynamic>.from(payload as Map);

  List<dynamic> get payloadList => List<dynamic>.from(payload as List);
}

/// Runs [call] and converts any [DioException] to [ApiException].
Future<T> guardApi<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (e) {
    throw ApiException.fromDio(e);
  }
}
