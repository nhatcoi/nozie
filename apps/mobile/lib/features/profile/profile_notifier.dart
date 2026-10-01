import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nozie_mobile/core/network/providers.dart';
import 'package:nozie_mobile/features/profile/user_profile.dart';
import 'package:nozie_mobile/features/profile/profile_api.dart';
import 'package:nozie_mobile/features/setting/settings_repository.dart';

class ProfileNotifier extends StateNotifier<AsyncValue<UserProfile>> {
  ProfileNotifier(this._repository, this._api, this._onProfileChanged) : super(const AsyncValue.loading()) {
    _load();
  }

  final SettingsRepository _repository;
  final ProfileApi _api;

  /// Keeps the session's copy of the user in step with edits.
  final void Function(UserProfile) _onProfileChanged;

  Future<void> _load() async {
    try {
      // Local cache first so the UI is instant; the server copy replaces it when reachable.
      final cached = await _repository.fetchProfile();
      state = AsyncValue.data(cached);
      final fresh = await _api.fetch();
      await _repository.updateProfile(fresh);
      state = AsyncValue.data(fresh);
    } catch (error, stack) {
      if (state is! AsyncData) state = AsyncValue.error(error, stack);
    }
  }

  Future<void> refresh() async => _load();

  /// Saves to the server (and uploads [avatar] if given). On failure the previous profile is restored and the
  /// error is rethrown so the screen can report it.
  Future<void> update(UserProfile profile, {File? avatar}) async {
    final previous = state;
    state = const AsyncValue.loading();
    try {
      var saved = await _api.update(profile);
      if (avatar != null) saved = await _api.uploadAvatar(avatar);
      await _repository.updateProfile(saved);
      _onProfileChanged(saved);
      state = AsyncValue.data(saved);
    } catch (_) {
      state = previous;
      rethrow;
    }
  }

  void setProfile(UserProfile profile) {
    state = AsyncValue.data(profile);
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<UserProfile>>((ref) {
  final session = ref.watch(sessionStoreProvider);
  return ProfileNotifier(
    ref.watch(settingsRepositoryProvider),
    ProfileApi(ref.watch(dioProvider)),
    session.updateUser,
  );
});
