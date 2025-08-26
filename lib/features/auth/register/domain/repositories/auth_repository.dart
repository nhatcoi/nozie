import '../entities/user_registration.dart';

abstract class AuthRepository {
  Future<void> registerUser(UserReg userRegistration);
  Future<bool> checkEmailAvailability(String email);
  Future<bool> checkUsernameAvailability(String username);
}

