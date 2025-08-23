import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_registration.dart';
import '../../domain/usecases/register_user_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';

// Repository Provider
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl();
});

// Use Case Provider
final registerUserUseCaseProvider = Provider<RegisterUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUserUseCase(repository);
});

// ViewModel Provider
final signupViewModelProvider = StateNotifierProvider<SignupViewModel, SignupState>((ref) {
  final useCase = ref.watch(registerUserUseCaseProvider);
  return SignupViewModel(useCase);
});

// State Class
class SignupState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final UserRegistration? userData;

  const SignupState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.userData,
  });

  SignupState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
    UserRegistration? userData,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
      userData: userData ?? this.userData,
    );
  }
}

// ViewModel Class
class SignupViewModel extends StateNotifier<SignupState> {
  final RegisterUserUseCase _registerUserUseCase;

  SignupViewModel(this._registerUserUseCase) : super(const SignupState());

  Future<void> registerUser({
    String? gender,
    String? age,
    List<String> genres = const [],
    required Map<String, String> profileData,
    required Map<String, dynamic> accountData,
  }) async {
    try {
      // Set loading state
      state = state.copyWith(isLoading: true, error: null);

      // Create UserProfile
      final userProfile = UserProfile(
        fullName: profileData['fullName'] ?? '',
        phone: profileData['phone'] ?? '',
        dateOfBirth: profileData['dob'] ?? '',
        country: profileData['country'] ?? '',
      );

      // Create UserAccount
      final userAccount = UserAccount(
        username: accountData['username'] ?? '',
        email: accountData['email'] ?? '',
        password: accountData['password'] ?? '',
        rememberMe: accountData['rememberMe'] ?? false,
      );

      // Create UserRegistration
      final userRegistration = UserRegistration(
        gender: gender,
        age: age,
        genres: genres,
        profile: userProfile,
        account: userAccount,
      );

      // Execute registration
      await _registerUserUseCase.execute(userRegistration);

      // Set success state
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        userData: userRegistration,
      );
    } catch (e) {
      // Set error state
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void resetState() {
    state = const SignupState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

