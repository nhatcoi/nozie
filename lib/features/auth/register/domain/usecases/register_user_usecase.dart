import '../entities/user_registration.dart';
import '../repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<void> execute(UserRegistration userRegistration) async {
    // Validate user registration data
    _validateUserRegistration(userRegistration);
    
    // Register user
    await repository.registerUser(userRegistration);
  }

  void _validateUserRegistration(UserRegistration userRegistration) {
    // Validate profile
    if (userRegistration.profile.fullName.isEmpty) {
      throw Exception('Full name is required');
    }
    if (userRegistration.profile.phone.isEmpty) {
      throw Exception('Phone number is required');
    }
    if (userRegistration.profile.dateOfBirth.isEmpty) {
      throw Exception('Date of birth is required');
    }
    if (userRegistration.profile.country.isEmpty) {
      throw Exception('Country is required');
    }

    // Validate account
    if (userRegistration.account.username.isEmpty) {
      throw Exception('Username is required');
    }
    if (userRegistration.account.email.isEmpty) {
      throw Exception('Email is required');
    }
    if (userRegistration.account.password.isEmpty) {
      throw Exception('Password is required');
    }
  }
}

