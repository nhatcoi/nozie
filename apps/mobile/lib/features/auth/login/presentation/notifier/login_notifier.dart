import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common/ui_state.dart';
import '../../../../../core/network/providers.dart';
import '../../../../profile/notifiers/profile_notifier.dart';
import '../../../../profile/repository/settings_repository.dart';
import '../../../shared/providers/auth_repository_provider.dart';
import '../../../register/domain/repositories/auth_repository.dart';

final loginNotifierProvider =
    StateNotifierProvider<LoginNotifier, UIState<bool>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginNotifier(ref, repository);
});

class LoginNotifier extends StateNotifier<UIState<bool>> {
  LoginNotifier(this._ref, this._repository) : super(const Idle<bool>());

  final Ref _ref;
  final AuthRepository _repository;

  Future<void> signIn({required String email, required String password}) =>
      _run(() => _repository.signIn(email: email, password: password));

  Future<void> signInWithGoogle() => _run(_repository.signInWithGoogle);

  void reset() {
    state = const Idle<bool>();
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      state = const Loading<bool>();
      await action();
      await _publishProfile();
      state = const Success<bool>(true);
    } catch (error) {
      state = Error<bool>(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Mirrors the logged-in user into the profile screens' local cache.
  Future<void> _publishProfile() async {
    try {
      final user = _ref.read(sessionStoreProvider).value.user;
      if (user == null) return;
      await _ref.read(settingsRepositoryProvider).updateProfile(user);
      _ref.read(profileNotifierProvider.notifier).setProfile(user);
    } catch (error) {
      debugPrint('Failed to publish user profile: $error');
    }
  }
}
