import 'package:dio/dio.dart';
import 'package:lumiere/core/network/api_constants.dart';
import 'package:lumiere/core/network/guard_api.dart';
import 'package:lumiere/core/storage/auth_tokens.dart';
import 'package:lumiere/core/storage/token_storage.dart';
import 'package:lumiere/features/auth/data/auth_repository.dart';
import 'package:lumiere/features/auth/data/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.dio, this.storage);

  final Dio dio;
  final TokenStorage storage;

  @override
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) => guardApi(
    () => dio.post(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      },
    ),
  );

  @override
  Future<void> verifyEmail({required String email, required String otp}) =>
      guardApi(
        () => dio.post(
          ApiConstants.verifyEmail,
          data: {'email': email, 'otp': otp},
        ),
      );

  @override
  Future<void> resendOtp(String email) =>
      guardApi(() => dio.post(ApiConstants.resendOtp, data: {'email': email}));

  @override
  Future<void> login({required String email, required String password}) =>
      guardApi(() async {
        final res = await dio.post(
          ApiConstants.login,
          data: {'email': email, 'password': password},
        );
        await storage.save(
          AuthTokens.fromJson(res.data as Map<String, dynamic>),
        );
      });

  @override
  Future<void> forgotPassword(String email) => guardApi(
    () => dio.post(ApiConstants.forgotPassword, data: {'email': email}),
  );

  @override
  Future<void> validateOtp({required String email, required String otp}) =>
      guardApi(
        () => dio.post(
          ApiConstants.validateOtp,
          data: {'email': email, 'otp': otp},
        ),
      );

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) => guardApi(
    () => dio.post(
      ApiConstants.resetPassword,
      data: {'email': email, 'otp': otp, 'newPassword': newPassword},
    ),
  );

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) => guardApi(
    () => dio.post(
      ApiConstants.changePassword,
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      },
    ),
  );

  @override
  Future<UserModel> getMe() => guardApi(() async {
    final res = await dio.get(ApiConstants.me);
    return UserModel.fromJson(res.data as Map<String, dynamic>);
  });

  @override
  Future<bool> hasSession() => storage.hasSession();

  @override
  Future<void> logout() async {
    try {
      final refreshToken = await storage.getRefreshToken();
      await dio.post(
        ApiConstants.logout,
        data: {'refreshToken': refreshToken},
      );
    } catch (_) {
    } finally {
      await storage.clear();
    }
  }
}
