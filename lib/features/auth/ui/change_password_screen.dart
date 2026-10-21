import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/utils/validators.dart';
import 'package:lumiere/core/widgets/auth/auth_button.dart';
import 'package:lumiere/core/widgets/auth/auth_scaffold.dart';
import 'package:lumiere/core/widgets/auth/password_text_field.dart';
import 'package:lumiere/core/widgets/auth/snack_bar.dart';
import 'package:lumiere/features/auth/cubit/auth_cubit.dart';
import 'package:lumiere/features/auth/cubit/auth_state.dart';
import 'package:lumiere/features/auth/data/auth_repository.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(context.read<AuthRepository>()),
      child: const ChangePasswordView(),
    );
  }
}

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView();

  @override
  State<ChangePasswordView> createState() => ChangePasswordViewState();
}

class ChangePasswordViewState extends State<ChangePasswordView> {
  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirm = TextEditingController();

  String? currentError;
  String? newError;
  String? confirmError;

  @override
  void dispose() {
    currentPassword.dispose();
    newPassword.dispose();
    confirm.dispose();
    super.dispose();
  }

  void _submit() {
    final currentError = currentPassword.text.isEmpty
        ? 'Please enter your current password.'
        : null;
    final newError = Validators.password(newPassword.text);
    final confirmError = Validators.confirmPassword(
      newPassword.text,
      confirm.text,
    );

    setState(() {
      this.currentError = currentError;
      this.newError = newError;
      this.confirmError = confirmError;
    });
    if (currentError != null || newError != null || confirmError != null) {
      return;
    }

    context.read<AuthCubit>().changePassword(
      currentPassword.text,
      newPassword.text,
      confirm.text,
    );
  }

  void onState(BuildContext context, AuthState state) {
    if (state is AuthSuccess && state.action == AuthAction.changePassword) {
      AppSnackBar.show(context, 'Password updated successfully');
      Navigator.pop(context);
      return;
    }
    if (state is! AuthFailure) return;

    final error = state.error;
    final currentMessage = error.fieldError('currentpassword');
    final newMessage =
        error.fieldError('newpassword') ?? error.fieldError('password');

    if (currentMessage != null || newMessage != null) {
      setState(() {
        currentError = currentMessage;
        newError = newMessage;
      });
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
          title: 'Change Password',
          child: Column(
            children: [
              PasswordTextField(
                controller: currentPassword,
                labelText: 'Current Password',
                hintText: '',
                errorText: currentError,
                onChanged: (_) {
                  if (currentError != null) {
                    setState(() => currentError = null);
                  }
                },
              ),
              SizedBox(height: 16),
              PasswordTextField(
                controller: newPassword,
                labelText: 'New Password',
                hintText: '',
                errorText: newError,
                onChanged: (_) {
                  if (newError != null) setState(() => newError = null);
                },
              ),
              SizedBox(height: 16),
              PasswordTextField(
                controller: confirm,
                labelText: 'Confirm New Password',
                hintText: '',
                errorText: confirmError,
                onChanged: (_) {
                  if (confirmError != null) {
                    setState(() => confirmError = null);
                  }
                },
              ),
              SizedBox(height: 32),
              AuthButton(
                text: 'Update password',
                isLoading: isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        );
      },
    );
  }
}
