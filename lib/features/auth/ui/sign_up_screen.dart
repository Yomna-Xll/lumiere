import 'package:flutter/material.dart';
import 'package:lumiere/core/utils/validators.dart';
import 'package:lumiere/core/widgets/auth/app_logo.dart';
import 'package:lumiere/core/widgets/auth/auth_button.dart';
import 'package:lumiere/core/widgets/auth/auth_footer_link.dart';
import 'package:lumiere/core/widgets/auth/auth_header.dart';
import 'package:lumiere/core/widgets/auth/auth_scaffold.dart';
import 'package:lumiere/core/widgets/auth/custom_text_field.dart';
import 'package:lumiere/core/widgets/auth/google_button.dart';
import 'package:lumiere/core/widgets/auth/or_divider.dart';
import 'package:lumiere/core/widgets/auth/password_text_field.dart';
import 'package:lumiere/features/auth/ui/verify_email_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  String? passwordError;
  bool isLoading = false;

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    final error = Validators.password(password.text);
    setState(() => passwordError = error);
    if (error != null) return;

    setState(() => isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(email: email.text.trim()),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      child: Column(
        children: [
          AppLogo(),
          SizedBox(height: 16),
          AuthHeader(
            title: 'Create account',
            subtitle: 'Join Lumière for bespoke fine jewelry experiences',
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  controller: firstName,
                  labelText: 'First Name',
                  hintText: 'Eleanor',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  controller: lastName,
                  labelText: 'Last Name',
                  hintText: 'Vane',
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          CustomTextField(
            controller: email,
            labelText: 'Email Address',
            hintText: 'eleanor.vane@domain.com',
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16),
          PasswordTextField(
            controller: password,
            hintText: '•••••••••••••',
            errorText: passwordError,
            helperText: passwordError == null
                ? 'At least 1 uppercase letter and 1 special character'
                : null,
            onChanged: (_) {
              if (passwordError != null) setState(() => passwordError = null);
            },
          ),
          SizedBox(height: 24),
          AuthButton(text: 'Sign Up', isLoading: isLoading, onPressed: signUp),
          SizedBox(height: 24),
          OrDivider(text: 'or continue with'),
          SizedBox(height: 24),
          GoogleButton(onPressed: () {}),
          SizedBox(height: 24),
          AuthFooterLink(
            normalText: 'Already have an account?',
            actionText: 'Login',
            onTap: () => Navigator.maybePop(context),
          ),
        ],
      ),
    );
  }
}
