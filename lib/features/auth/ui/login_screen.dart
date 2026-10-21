import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/theme/app_text_style.dart';
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
import 'package:lumiere/core/widgets/auth/snack_bar.dart';
import 'package:lumiere/features/auth/cubit/auth_cubit.dart';
import 'package:lumiere/features/auth/cubit/auth_state.dart';
import 'package:lumiere/features/auth/cubit/session_cubit.dart';
import 'package:lumiere/features/auth/data/auth_repository.dart';
import 'package:lumiere/features/auth/ui/forget_password_screen.dart';
import 'package:lumiere/features/auth/ui/sign_up_screen.dart';
import 'package:lumiere/features/auth/ui/verify_email_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(context.read<AuthRepository>()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView();

  @override
  State<LoginView> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final email = TextEditingController();
  final password = TextEditingController();
  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void submit() {
    final emailError = Validators.email(email.text);
    final passwordError = password.text.isEmpty
        ? 'Please enter your password.'
        : null;
    setState(() {
      this.emailError = emailError;
      this.passwordError = passwordError;
    });
    if (emailError != null || passwordError != null) return;
    context.read<AuthCubit>().login(email.text.trim(), password.text);
  }

  void onState(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      context.read<SessionCubit>().check();
      return;
    }
    if (state is! AuthFailure) return;

    final error = state.error;
    final emailMessage = error.fieldError('email');
    final passwordMessage = error.fieldError('password');

    if (emailMessage != null &&
        emailMessage.toLowerCase().contains('not verified')) {
      setState(() => emailError = emailMessage);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              VerifyEmailScreen(email: email.text.trim(), resendOnOpen: true),
        ),
      );
    } else if (emailMessage != null || passwordMessage != null) {
      setState(() {
        emailError = emailMessage;
        passwordError = passwordMessage;
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
        final isLoading = state is AuthLoading || state is AuthSuccess;
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
                controller: email,
                labelText: 'Email Address',
                hintText: 'name@example.com',
                keyboardType: TextInputType.emailAddress,
                errorText: emailError,
                onChanged: (_) {
                  if (emailError != null) setState(() => emailError = null);
                },
              ),
              SizedBox(height: 16),
              PasswordTextField(
                controller: password,
                errorText: passwordError,
                onChanged: (_) {
                  if (passwordError != null) {
                    setState(() => passwordError = null);
                  }
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ForgotPasswordScreen(initialEmail: email.text.trim()),
                    ),
                  ),
                  child: Text(
                    'Forgot password?',
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColors.gold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              AuthButton(
                text: 'Login',
                isLoading: isLoading,
                onPressed: submit,
              ),
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
      },
    );
  }
}
