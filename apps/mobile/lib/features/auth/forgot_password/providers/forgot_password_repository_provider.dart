import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/providers.dart';
import '../data/forgot_password_repository_impl.dart';
import '../domain/repositories/auth_repository.dart' as domain;

final forgotPasswordRepositoryProvider = Provider<domain.AuthRepository>((ref) {
  return ForgotPasswordRepositoryImpl(ref.watch(dioProvider));
});
