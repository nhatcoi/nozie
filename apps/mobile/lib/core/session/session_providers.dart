import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/profile/models/user_profile.dart';
import '../network/providers.dart';
import 'session_state.dart';

/// Current session, rebuilt whenever someone logs in or out.
final sessionStateProvider = Provider<SessionState>((ref) {
  final store = ref.watch(sessionStoreProvider);
  void onChange() => ref.invalidateSelf();
  store.addListener(onChange);
  ref.onDispose(() => store.removeListener(onChange));
  return store.value;
});

/// The logged-in user, or null when signed out.
final currentUserProvider = Provider<UserProfile?>((ref) => ref.watch(sessionStateProvider).user);
