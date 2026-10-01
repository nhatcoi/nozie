import '../models/user_registration.dart';

abstract class AuthRepository {
  Future<void> register(UserReg userRegistration);
  Future<void> signIn({required String email, required String password});
  Future<void> signInWithGoogle();

  /// Revokes the refresh token server-side and clears local credentials.
  Future<void> signOut();

  /// Called once at startup: validates stored tokens and loads the current user.
  Future<void> restoreSession();
}
