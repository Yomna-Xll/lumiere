import 'package:lumiere/features/auth/data/user_model.dart';

abstract class AuthRepository {
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });
  Future<void> verifyEmail({required String email, required String otp});
  Future<void> resendOtp(String email);
  Future<void> login({required String email, required String password});
  Future<void> forgotPassword(String email);
  Future<void> validateOtp({required String email, required String otp});
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  });
  Future<UserModel> getMe();
  Future<bool> hasSession();
  Future<void> logout();
}
