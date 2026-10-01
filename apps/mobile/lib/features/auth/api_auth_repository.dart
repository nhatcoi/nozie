import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:nozie_mobile/core/config/env.dart';
import 'package:nozie_mobile/core/network/api_exception.dart';
import 'package:nozie_mobile/core/network/api_response.dart';
import 'package:nozie_mobile/core/session/session_state.dart';
import 'package:nozie_mobile/core/storage/token_storage.dart';
import 'package:nozie_mobile/features/profile/user_profile.dart';
import 'package:nozie_mobile/features/profile/user_profile_api.dart';
import 'package:nozie_mobile/features/auth/user_registration.dart' as reg;
import 'package:nozie_mobile/features/auth/auth_repository.dart';

/// Talks to the Nozie API. Replaces the former Firebase Auth + Firestore implementation.
class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({
    required Dio dio,
    required TokenStorage tokens,
    required SessionStore session,
    GoogleSignIn? googleSignIn,
  })  : _dio = dio,
        _tokens = tokens,
        _session = session,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: const ['email'],
              serverClientId: Env.googleServerClientId.isEmpty ? null : Env.googleServerClientId,
            );

  final Dio _dio;
  final TokenStorage _tokens;
  final SessionStore _session;
  final GoogleSignIn _googleSignIn;

  @override
  Future<void> register(reg.UserReg registration) async {
    final account = registration.account;
    final email = account.email.trim();
    final password = account.password;
    if (email.isEmpty || password.isEmpty) {
      throw ApiException(code: 'VALIDATION_FAILED', message: 'Email and password are required');
    }

    final res = await guardApi(() => _dio.post<dynamic>('/auth/register', data: {
          'email': email,
          'password': password,
          'fullName': registration.profile.fullName.trim(),
        }));
    var user = await _acceptAuth(res.payloadMap);

    // Extra signup fields go through the profile endpoint. The account already exists at this
    // point, so a failure here (e.g. username taken) must not undo a successful registration.
    final draft = UserProfile(
      id: user.id,
      fullName: user.fullName,
      username: account.username,
      email: user.email,
      phone: registration.profile.phone,
      dateOfBirth: registration.profile.dateOfBirth,
      country: registration.profile.country,
      avatarUrl: '',
    );
    final patch = {
      ...draft.toApiPatch(),
      if ((registration.gender ?? '').isNotEmpty) 'gender': registration.gender,
    }..remove('fullName');
    if (registration.genres.isNotEmpty) {
      try {
        await _dio.put<dynamic>('/users/me/favorite-genres', data: {'genres': registration.genres});
      } on DioException catch (e) {
        debugPrint('[Auth] Favourite genres not saved: ${ApiException.fromDio(e).code}');
      }
    }
    if (patch.isNotEmpty) {
      try {
        final r = await _dio.patch<dynamic>('/users/me', data: patch);
        user = UserProfileApi.fromApi(r.payloadMap);
        _session.updateUser(user);
      } on DioException catch (e) {
        debugPrint('[Auth] Signup profile details not saved: ${ApiException.fromDio(e).code}');
      }
    }
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    final res = await guardApi(() => _dio.post<dynamic>('/auth/login', data: {
          'email': email.trim(),
          'password': password,
        }));
    await _acceptAuth(res.payloadMap);
  }

  @override
  Future<void> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw ApiException(code: 'CANCELLED', message: 'Google sign-in was cancelled');
    }
    final idToken = (await account.authentication).idToken;
    if (idToken == null) {
      throw ApiException(code: 'INVALID_GOOGLE_TOKEN', message: 'Google did not return an ID token');
    }
    final res = await guardApi(() => _dio.post<dynamic>('/auth/google', data: {'idToken': idToken}));
    await _acceptAuth(res.payloadMap);
  }

  @override
  Future<void> signOut() async {
    final refresh = await _tokens.readRefreshToken();
    if (refresh != null) {
      try {
        await _dio.post<dynamic>('/auth/logout', data: {'refreshToken': refresh});
      } catch (_) {
        // Best effort: local credentials are cleared regardless.
      }
    }
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _tokens.clear();
    _session.expire();
  }

  @override
  Future<void> restoreSession() async {
    final access = await _tokens.readAccessToken();
    final refresh = await _tokens.readRefreshToken();
    if (access == null && refresh == null) {
      _session.expire();
      return;
    }
    try {
      final res = await _dio.get<dynamic>('/users/me');
      _session.authenticate(UserProfileApi.fromApi(res.payloadMap));
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        await _tokens.clear();
      }
      // Offline at startup keeps the tokens so the next launch can still resume.
      _session.expire();
    }
  }

  /// Stores the token pair, publishes the user, returns it.
  Future<UserProfile> _acceptAuth(Map<String, dynamic> data) async {
    await _tokens.save(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
    final user = UserProfileApi.fromApi(Map<String, dynamic>.from(data['user'] as Map));
    _session.authenticate(user);
    return user;
  }
}
