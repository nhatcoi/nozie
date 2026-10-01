import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/env.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

/// The one and only HTTP client for the Nozie API.
Dio buildApiClient({
  required TokenStorage tokens,
  required void Function() onSessionExpired,
  String? baseUrl,
  HttpClientAdapter? adapter,
}) {
  final options = BaseOptions(
    baseUrl: baseUrl ?? Env.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  );

  final dio = Dio(options);
  final refreshDio = Dio(options);
  if (adapter != null) {
    dio.httpClientAdapter = adapter;
    refreshDio.httpClientAdapter = adapter;
  }

  dio.interceptors.add(AuthInterceptor(
    dio: dio,
    tokens: tokens,
    refreshDio: refreshDio,
    onSessionExpired: onSessionExpired,
  ));

  if (kDebugMode) {
    // Never log bodies/headers: they contain passwords and tokens.
    dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: false, requestHeader: false));
  }
  return dio;
}
