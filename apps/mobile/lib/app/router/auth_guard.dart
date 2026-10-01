import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:nozie_mobile/core/session/session_state.dart';

class AuthGuard {
  AuthGuard({
    required SessionStore session,
    Set<String>? publicPaths,
    Set<String>? authRedirectWhitelist,
  })  : _session = session,
        _publicPaths = publicPaths ?? const {
          '/',
          '/signup',
          '/sign-in',
          '/forgot-password',
          '/otp-verification',
          '/reset-password',
        },
        _authRedirectWhitelist = authRedirectWhitelist ?? const {
          '/',
          '/sign-in',
          '/signup',
        };

  final SessionStore _session;
  final Set<String> _publicPaths;
  final Set<String> _authRedirectWhitelist;

  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = _session.value.isAuthenticated;
    final location = _normalize(state.matchedLocation);

    if (!isLoggedIn && !_publicPaths.contains(location)) {
      return '/sign-in';
    }

    if (isLoggedIn && _authRedirectWhitelist.contains(location)) {
      return '/home';
    }

    return null;
  }

  String _normalize(String location) {
    if (location.isEmpty) return '/';
    final uri = Uri.parse(location);
    final path = uri.path;
    return path.isEmpty ? '/' : path;
  }
}
