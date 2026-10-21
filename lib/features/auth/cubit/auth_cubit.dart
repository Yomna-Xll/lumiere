import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/network/api_error.dart';
import 'package:lumiere/features/auth/cubit/auth_state.dart';
import 'package:lumiere/features/auth/data/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repo) : super(const AuthInitial());

  final AuthRepository _repo;

  Future<void> _run(AuthAction action, Future<void> Function() call) async {
    emit(AuthLoading(action));
    try {
      await call();
      if (isClosed) return;
      emit(AuthSuccess(action));
    } on ApiError catch (e) {
      if (isClosed) return;
      emit(AuthFailure(action, e));
    }
  }

  Future<void> login(String email, String password) => _run(
    AuthAction.login,
    () => _repo.login(email: email, password: password),
  );

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) => _run(
    AuthAction.register,
    () => _repo.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    ),
  );

  Future<void> verifyEmail(String email, String otp) => _run(
    AuthAction.verifyEmail,
    () => _repo.verifyEmail(email: email, otp: otp),
  );

  Future<void> resendOtp(String email) =>
      _run(AuthAction.resendOtp, () => _repo.resendOtp(email));

  Future<void> forgotPassword(String email) =>
      _run(AuthAction.forgotPassword, () => _repo.forgotPassword(email));

  Future<void> validateOtp(String email, String otp) => _run(
    AuthAction.validateOtp,
    () => _repo.validateOtp(email: email, otp: otp),
  );

  Future<void> resetPassword(String email, String otp, String newPassword) =>
      _run(
        AuthAction.resetPassword,
        () => _repo.resetPassword(
          email: email,
          otp: otp,
          newPassword: newPassword,
        ),
      );

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    String confirmNewPassword,
  ) => _run(
    AuthAction.changePassword,
    () => _repo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    ),
  );
}
