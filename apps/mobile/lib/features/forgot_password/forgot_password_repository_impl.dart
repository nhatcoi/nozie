import 'package:dio/dio.dart';

import 'package:nozie_mobile/core/network/api_exception.dart';
import 'package:nozie_mobile/core/network/api_response.dart';
import 'package:nozie_mobile/features/forgot_password/password_reset_repository.dart' as domain;

class ForgotPasswordRepositoryImpl implements domain.AuthRepository {
  ForgotPasswordRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> resendOtp({required String email}) async {
    await guardApi(() => _dio.post<dynamic>('/auth/password/otp', data: {'email': email.trim()}));
  }

  @override
  Future<String> verifyOtp({required String email, required String code}) async {
    final res = await guardApi(
        () => _dio.post<dynamic>('/auth/password/verify', data: {'email': email.trim(), 'code': code}));
    final token = res.payloadMap['resetToken'] as String?;
    if (token == null || token.isEmpty) {
      throw ApiException(code: 'UNKNOWN', message: 'Missing reset token');
    }
    return token;
  }

  /// The reset token already identifies the account, so [email] is not sent.
  @override
  Future<void> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
  }) async {
    await guardApi(() => _dio.post<dynamic>('/auth/password/reset',
        data: {'resetToken': resetToken, 'newPassword': newPassword}));
  }
}
