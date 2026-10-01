import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../session/session_state.dart';
import '../storage/token_storage.dart';
import 'api_client.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

/// Created in `main()` (so the router can listen to it before the widget tree exists) and overridden there.
final sessionStoreProvider = Provider<SessionStore>((ref) => throw UnimplementedError('override in main()'));

final dioProvider = Provider<Dio>((ref) {
  final session = ref.watch(sessionStoreProvider);
  return buildApiClient(
    tokens: ref.watch(tokenStorageProvider),
    onSessionExpired: session.expire,
  );
});
