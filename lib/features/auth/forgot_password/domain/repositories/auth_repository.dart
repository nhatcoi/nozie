abstract class AuthRepository {
  Future<void> verifyOtp({required String email, required String code});
  Future<void> resendOtp({required String email});
}
