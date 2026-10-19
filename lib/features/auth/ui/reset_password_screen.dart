import 'package:flutter/material.dart';
import 'package:lumiere/core/utils/validators.dart';
import 'package:lumiere/core/widgets/auth/auth_button.dart';
import 'package:lumiere/core/widgets/auth/auth_header.dart';
import 'package:lumiere/core/widgets/auth/auth_scaffold.dart';
import 'package:lumiere/core/widgets/auth/password_text_field.dart';
import 'package:lumiere/features/auth/ui/password_update_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final password = TextEditingController();
  final confirm = TextEditingController();
  String? passwordError;
  String? confirmError;
  bool isLoading = false;

  @override
  void dispose() {
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  Future<void> reset() async {
    final perr = Validators.password(password.text);
    final cerr = Validators.confirmPassword(password.text, confirm.text);
    setState(() {
      passwordError = perr;
      confirmError = cerr;
    });
    if (perr != null || cerr != null) return;
    setState(() {
      passwordError = perr;
      confirmError = cerr;
    });
    if (perr != null || cerr != null) return;

    setState(() => isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => PasswordUpdatedScreen()),
        (route) => false,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          ),
          SizedBox(height: 16),
          PasswordTextField(
            controller: confirm,
            labelText: 'Confirm Password',
            hintText: '•••••••••••••',
            errorText: confirmError,
            helperText: 'At least 1 uppercase letter and 1 special character',
          ),
          SizedBox(height: 24),
          AuthButton(
            text: 'Reset password',
            isLoading: isLoading,
            onPressed: reset,
          ),
        ],
      ),
    );
  }
}
