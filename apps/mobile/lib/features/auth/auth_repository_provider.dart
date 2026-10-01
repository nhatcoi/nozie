import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nozie_mobile/core/network/providers.dart';
import 'package:nozie_mobile/features/auth/api_auth_repository.dart';
import 'package:nozie_mobile/features/auth/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ApiAuthRepository(
    dio: ref.watch(dioProvider),
    tokens: ref.watch(tokenStorageProvider),
    session: ref.watch(sessionStoreProvider),
  );
});
