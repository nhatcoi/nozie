import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/common/ui_state.dart';
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
final signupViewModelProvider = StateNotifierProvider<SignupViewModel, UIState<UserReg>>((ref) {
  final useCase = ref.watch(registerUserUseCaseProvider);
  return SignupViewModel(useCase);
});

// ViewModel Class
class SignupViewModel extends StateNotifier<UIState<UserReg>> {
  final RegisterUserUseCase _registerUserUseCase;

  SignupViewModel(this._registerUserUseCase) : super(const Idle<UserReg>());

  Future<UIState<UserReg>> registerUser({
    String? gender,
    String? age,
    List<String> genres = const [],
    required Map<String, String> profileData,
    required Map<String, dynamic> accountData,
  }) async {
    try {

      final userProfile = UserProfile(
        fullName: profileData['fullName'] ?? '',
        phone: profileData['phone'] ?? '',
        dateOfBirth: profileData['dob'] ?? '',
        country: profileData['country'] ?? '',
      );

      final userAccount = UserAccount(
        username: accountData['username'] ?? '',
        email: accountData['email'] ?? '',
        password: accountData['password'] ?? '',
        rememberMe: accountData['rememberMe'] ?? false,
      );

      final userRegistration = UserReg(
        gender: gender,
        age: age,
        genres: genres,
        profile: userProfile,
        account: userAccount,
      );

      state = const Loading<UserReg>();

      await _registerUserUseCase.execute(userRegistration);

      state = Success<UserReg>(userRegistration);
      return state;
    } catch (e) {
      state = Error<UserReg>(e.toString());
      return state;
    }
  }

}

