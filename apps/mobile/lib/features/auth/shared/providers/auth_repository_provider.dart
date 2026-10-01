import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/providers.dart';
import '../../data/api_auth_repository.dart';
import '../../register/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ApiAuthRepository(
    dio: ref.watch(dioProvider),
    tokens: ref.watch(tokenStorageProvider),
    session: ref.watch(sessionStoreProvider),
  );
});
