import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/theme/app_text_style.dart';
import 'package:lumiere/core/widgets/app_logo.dart';
import 'package:lumiere/core/widgets/auth_button.dart';
import 'package:lumiere/core/widgets/auth_footer_link.dart';
import 'package:lumiere/core/widgets/auth_header.dart';
import 'package:lumiere/core/widgets/auth_scaffold.dart';
import 'package:lumiere/core/widgets/custom_text_field.dart';
import 'package:lumiere/core/widgets/google_button.dart';
import 'package:lumiere/core/widgets/or_divider.dart';
import 'package:lumiere/core/widgets/password_text_field.dart';
import 'package:lumiere/core/widgets/snack_bar.dart';
import 'package:lumiere/features/auth/ui/forget_password_screen.dart';
import 'package:lumiere/features/auth/ui/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError; // "Email not verified, please verify your email first."
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    setState(() {
      emailError = null;
      isLoading = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      setState(
        () =>
            emailError = 'Email not verified, please verify your email first.',
      );
    } catch (_) {
      if (mounted) {
        AppSnackBar.show(
          context,
          'Something went wrong, please try again',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        children: [
          AppLogo(),
          SizedBox(height: 24),
          AuthHeader(
            title: 'Welcome back',
            subtitle: 'Sign in to access your curated collection',
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          SizedBox(height: 32),
          CustomTextField(
            controller: emailController,
            labelText: 'Email Address',
            hintText: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
            errorText: emailError,
            onChanged: (_) {
              if (emailError != null) setState(() => emailError = null);
            },
          ),
          SizedBox(height: 16),
          PasswordTextField(controller: passwordController),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ForgotPasswordScreen(
                    initialEmail: emailController.text.trim(),
                  ),
                ),
              ),
              child: Text(
                'Forgot password?',
                style: AppTextStyle.bodyMedium.copyWith(color: AppColors.gold),
              ),
            ),
          ),
          SizedBox(height: 8),
          AuthButton(text: 'Login', isLoading: isLoading, onPressed: login),
          SizedBox(height: 24),
          OrDivider(),
          SizedBox(height: 24),
          GoogleButton(onPressed: () {}),
          SizedBox(height: 24),
          AuthFooterLink(
            normalText: "Don't have an account?",
            actionText: 'Sign up',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SignUpScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
