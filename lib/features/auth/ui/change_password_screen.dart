import 'package:flutter/material.dart';
import 'package:lumiere/core/utils/validators.dart';
import 'package:lumiere/core/widgets/auth_button.dart';
import 'package:lumiere/core/widgets/auth_scaffold.dart';
import 'package:lumiere/core/widgets/password_text_field.dart';
import 'package:lumiere/core/widgets/snack_bar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final current = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  String? newError;
  String? confirmError;
  bool isLoading = false;

  @override
  void dispose() {
    current.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

 Future<void> update() async {
    final nerr = Validators.password(newPassword.text);
    final cerr = Validators.confirmPassword(newPassword.text, confirmPassword.text); 

    setState(() {
      newError = nerr;
      confirmError = cerr;
    });

    if (nerr != null || cerr != null) return;

    setState(() => isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      AppSnackBar.show(context, 'Password updated successfully');
      Navigator.maybePop(context);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      title: 'Change Password',
      child: Column(
        children: [
          PasswordTextField(
            controller: current,
            labelText: 'Current Password',
            hintText: '',
          ),
          SizedBox(height: 16),
          PasswordTextField(
            controller: newPassword,
            labelText: 'New Password',
            hintText: '',
            errorText: newError,
          ),
          SizedBox(height: 16),
          PasswordTextField(
            controller: confirmPassword,
            labelText: 'Confirm New Password',
            hintText: '',
            errorText: confirmError,
          ),
          SizedBox(height: 32),
          AuthButton(
            text: 'Update password',
            isLoading: isLoading,
            onPressed: update,
          ),
        ],
      ),
    );
  }
}
