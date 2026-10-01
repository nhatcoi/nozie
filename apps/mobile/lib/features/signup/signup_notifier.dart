import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nozie_mobile/core/common/ui_state.dart';
import 'package:nozie_mobile/core/network/providers.dart';
import 'package:nozie_mobile/features/auth/auth_repository_provider.dart';
import 'package:nozie_mobile/features/auth/user_registration.dart';
import 'package:nozie_mobile/features/auth/auth_repository.dart';
import 'package:nozie_mobile/features/profile/profile_notifier.dart';
import 'package:nozie_mobile/features/profile/profile_api.dart';
import 'package:nozie_mobile/features/setting/settings_repository.dart';

final signupNotifierProvider =
    StateNotifierProvider<SignupNotifier, UIState<UserReg>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignupNotifier(ref, repository);
});

class SignupNotifier extends StateNotifier<UIState<UserReg>> {
  SignupNotifier(this._ref, this._repository) : super(const Idle<UserReg>());

  final Ref _ref;
  final AuthRepository _repository;

  Future<UIState<UserReg>> registerUser({
    String? gender,
    String? age,
    List<String> genres = const [],
    required Map<String, String> profileData,
    required Map<String, dynamic> accountData,
  }) async {
    try {
      state = const Loading<UserReg>();

      final userProfile = UserProfile(
        fullName: (profileData['fullName'] ?? '').trim(),
        phone: (profileData['phone'] ?? '').trim(),
        dateOfBirth: (profileData['dob'] ?? '').trim(),
        country: (profileData['country'] ?? '').trim(),
      );

      final userAccount = UserAccount(
        username: (accountData['username'] ?? '').trim(),
        email: (accountData['email'] ?? '').trim(),
        password: (accountData['password'] ?? '').trim(),
        rememberMe: accountData['rememberMe'] ?? false,
      );

      final userRegistration = UserReg(
        gender: gender,
        age: age,
        genres: genres,
        profile: userProfile,
        account: userAccount,
      );

      await _repository.register(userRegistration);

      // The avatar goes up once the account exists; losing it must not undo a successful signup.
      final avatarPath = profileData['avatarPath'];
      if (avatarPath != null && avatarPath.isNotEmpty) {
        try {
          final file = File(avatarPath);
          if (await file.exists()) {
            final updated = await ProfileApi(_ref.read(dioProvider)).uploadAvatar(file);
            _ref.read(sessionStoreProvider).updateUser(updated);
          }
        } catch (error) {
          debugPrint('[SignupNotifier] Avatar upload failed: $error');
        }
      }

      await _publishProfile();

      state = Success<UserReg>(userRegistration);
      return state;
    } catch (error) {
      state = Error<UserReg>(error.toString());
      return state;
    }
  }

  Future<void> signInWithGoogle() async {
    await _repository.signInWithGoogle();
    await _publishProfile();
  }

  Future<void> _publishProfile() async {
    try {
      final user = _ref.read(sessionStoreProvider).value.user;
      if (user == null) return;
      await _ref.read(settingsRepositoryProvider).updateProfile(user);
      _ref.read(profileNotifierProvider.notifier).setProfile(user);
    } catch (error) {
      debugPrint('Failed to publish user profile after signup: $error');
    }
  }
}
