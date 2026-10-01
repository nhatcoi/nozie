import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nozie_mobile/features/profile/user_profile.dart';
import 'package:nozie_mobile/core/network/providers.dart';
import 'package:nozie_mobile/core/session/session_state.dart';

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
