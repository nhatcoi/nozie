import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nozie_mobile/features/auth/forgot_password/data/forgot_password_repository_impl.dart';
import 'package:nozie_mobile/features/auth/forgot_password/domain/repositories/auth_repository.dart' as domain;

final forgotBaseUrlProvider = Provider<String>((ref) {
  // Local dev server; adjust if needed
  return 'http://localhost:3000';
});

final forgotPasswordRepositoryProvider = Provider<domain.AuthRepository>((ref) {
  final baseUrl = ref.watch(forgotBaseUrlProvider);
  return ForgotPasswordRepositoryImpl(baseUrl: baseUrl);
});


