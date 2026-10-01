import 'package:dio/dio.dart';

/// Error raised for any failed API call. UI switches on [code], never on [message].
class ApiException implements Exception {
  ApiException({required this.code, required this.message, this.statusCode, this.fieldErrors = const {}});

  /// Server `ErrorCode` name, e.g. `INVALID_CREDENTIALS`, or a client-side one: `NETWORK`, `TIMEOUT`, `UNKNOWN`.
  final String code;
  final String message;
  final int? statusCode;

  /// Field → message, populated for `VALIDATION_FAILED`.
  final Map<String, String> fieldErrors;

  bool get isUnauthorized => statusCode == 401;

  factory ApiException.fromDio(DioException e) {
    final body = e.response?.data;
    if (body is Map && body['data'] is Map) {
      final data = body['data'] as Map;
      final violations = <String, String>{};
      final raw = data['violations'];
      if (raw is List) {
        for (final v in raw) {
          if (v is Map && v['field'] != null) {
            violations[v['field'].toString()] = (v['message'] ?? '').toString();
          }
        }
      }
      return ApiException(
        code: (data['code'] ?? 'UNKNOWN').toString(),
        message: (body['message'] ?? 'Request failed').toString(),
        statusCode: e.response?.statusCode,
        fieldErrors: violations,
      );
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(code: 'TIMEOUT', message: 'The server took too long to respond');
      case DioExceptionType.connectionError:
        return ApiException(code: 'NETWORK', message: 'Cannot reach the server');
      default:
        return ApiException(
          code: 'UNKNOWN',
          message: e.message ?? 'Unexpected error',
          statusCode: e.response?.statusCode,
        );
    }
  }

  @override
  String toString() => message;
}
