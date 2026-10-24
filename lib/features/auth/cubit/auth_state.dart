import 'package:equatable/equatable.dart';
 import 'package:lumiere/core/network/api_error.dart';

enum AuthAction {
  login,
  register,
  verifyEmail,
  resendOtp,
  forgotPassword,
  validateOtp,
  resetPassword,
  changePassword,
}

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}



class AuthLoading extends AuthState {
  final AuthAction action;
  const AuthLoading(this.action);

  @override
  List<Object?> get props => [action];
}

class AuthSuccess extends AuthState {
  final AuthAction action;
  const AuthSuccess(this.action);

  @override
  List<Object?> get props => [action];
}

class AuthFailure extends AuthState {
  final AuthAction action;
  final ApiError error;
  const AuthFailure(this.action, this.error);

  @override
  List<Object?> get props => [action, error.message, error.statusCode];
}