import 'package:flutter/foundation.dart';

import 'package:nozie_mobile/features/profile/user_profile.dart';

enum SessionStatus { unknown, authenticated, unauthenticated }

@immutable
class SessionState {
  const SessionState(this.status, [this.user]);

  const SessionState.unknown() : this(SessionStatus.unknown);
  const SessionState.unauthenticated() : this(SessionStatus.unauthenticated);
  const SessionState.authenticated(UserProfile user) : this(SessionStatus.authenticated, user);

  final SessionStatus status;
  final UserProfile? user;

  bool get isAuthenticated => status == SessionStatus.authenticated;
}

/// Holds who is logged in. A [ValueNotifier] so go_router can use it as `refreshListenable`
/// and the HTTP layer can flip it to unauthenticated when a refresh fails.
class SessionStore extends ValueNotifier<SessionState> {
  SessionStore() : super(const SessionState.unknown());

  void authenticate(UserProfile user) => value = SessionState.authenticated(user);

  void updateUser(UserProfile user) {
    if (value.isAuthenticated) value = SessionState.authenticated(user);
  }

  void expire() => value = const SessionState.unauthenticated();
}
