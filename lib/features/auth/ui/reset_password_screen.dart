import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/utils/validators.dart';
import 'package:lumiere/core/widgets/auth/auth_button.dart';
import 'package:lumiere/core/widgets/auth/auth_header.dart';
import 'package:lumiere/core/widgets/auth/auth_scaffold.dart';
import 'package:lumiere/core/widgets/auth/password_text_field.dart';
import 'package:lumiere/core/widgets/auth/snack_bar.dart';
import 'package:lumiere/features/auth/cubit/auth_cubit.dart';
import 'package:lumiere/features/auth/cubit/auth_state.dart';
import 'package:lumiere/features/auth/data/auth_repository.dart';
import 'package:lumiere/features/auth/ui/password_update_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(context.read<AuthRepository>()),
      child: _ResetPasswordView(email: email, otp: otp),
    );
  }
}

class _ResetPasswordView extends StatefulWidget {
  const _ResetPasswordView({required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  State<_ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<_ResetPasswordView> {
  final password = TextEditingController();
  final confirm = TextEditingController();
  String? passwordError;
  String? confirmError;

  @override
  void dispose() {
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  void submit() {
    final passwordError = Validators.password(password.text);
    final confirmError = Validators.confirmPassword(
      password.text,
      confirm.text,
    );
    setState(() {
      this.passwordError = passwordError;
      this.confirmError = confirmError;
    });
    if (passwordError != null || confirmError != null) return;

    context.read<AuthCubit>().resetPassword(
      widget.email,
      widget.otp,
      password.text,
    );
  }

  void onState(BuildContext context, AuthState state) {
    if (state is AuthSuccess && state.action == AuthAction.resetPassword) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const PasswordUpdatedScreen()),
        (route) => false,
      );
      return;
    }
    if (state is! AuthFailure) return;

    final error = state.error;
    final passwordMessage =
        error.fieldError('newpassword') ?? error.fieldError('password');

    if (passwordMessage != null) {
      setState(() => passwordError = passwordMessage);
    } else {
      AppSnackBar.show(context, error.message, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: onState,
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return AuthScaffold(
          showBackButton: true,
          title: 'Reset Password',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHeader(
                title: 'Create new password',
                subtitle: 'Enter your new password below',
              ),
              SizedBox(height: 24),
              PasswordTextField(
                controller: password,
                labelText: 'New Password',
                hintText: '•••••••••••••',
                errorText: passwordError,
                helperText: passwordError == null
                    ? 'At least 1 uppercase letter and 1 special character'
                    : null,
                onChanged: (_) {
                  if (passwordError != null) {
                    setState(() => passwordError = null);
                  }
                },
              ),
              SizedBox(height: 16),
              PasswordTextField(
                controller: confirm,
                labelText: 'Confirm Password',
                hintText: '•••••••••••••',
                errorText: confirmError,
                onChanged: (_) {
                  if (confirmError != null) {
                    setState(() => confirmError = null);
                  }
                },
              ),
              SizedBox(height: 24),
              AuthButton(
                text: 'Reset password',
                isLoading: isLoading,
                onPressed: submit,
              ),
            ],
          ),
        );
      },
    );
  }
}
