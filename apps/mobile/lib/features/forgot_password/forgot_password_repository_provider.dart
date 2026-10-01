import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nozie_mobile/core/network/providers.dart';
import 'package:nozie_mobile/features/forgot_password/forgot_password_repository_impl.dart';
import 'package:nozie_mobile/features/forgot_password/password_reset_repository.dart' as domain;

final forgotPasswordRepositoryProvider = Provider<domain.AuthRepository>((ref) {
  return ForgotPasswordRepositoryImpl(ref.watch(dioProvider));
});
