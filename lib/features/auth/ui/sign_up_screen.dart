import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:lumiere/features/auth/data/auth_repository.dart';
import 'package:lumiere/features/auth/ui/verify_email_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(context.read<AuthRepository>()),
      child: SignUpView(),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView();

  @override
  State<SignUpView> createState() => SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  String? firstNameError;
  String? lastNameError;
  String? emailError;
  String? _passwordError;

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void _submit() {
    final firstNameError = firstName.text.trim().isEmpty ? 'Required.' : null;
    final lastNameError = lastName.text.trim().isEmpty ? 'Required.' : null;
    final emailError = Validators.email(email.text);
    final passwordError = Validators.password(password.text);

    setState(() {
      this.firstNameError = firstNameError;
      this.lastNameError = lastNameError;
      this.emailError = emailError;
      _passwordError = passwordError;
    });

    if (firstNameError != null ||
        lastNameError != null ||
        emailError != null ||
        passwordError != null) {
      return;
    }

    context.read<AuthCubit>().register(
      email: email.text.trim(),
      password: password.text,
      firstName: firstName.text.trim(),
      lastName: lastName.text.trim(),
    );
  }

  void _onState(BuildContext context, AuthState state) {
    if (state is AuthSuccess && state.action == AuthAction.register) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(email: email.text.trim()),
        ),
      );
      return;
    }
    if (state is! AuthFailure) return;

    final error = state.error;
    final firstNameMessage = error.fieldError('firstname');
    final lastNameMessage = error.fieldError('lastname');
    final emailMessage = error.fieldError('email');
    final passwordMessage = error.fieldError('password');

    if (firstNameMessage != null ||
        lastNameMessage != null ||
        emailMessage != null ||
        passwordMessage != null) {
      setState(() {
        firstNameError = firstNameMessage;
        lastNameError = lastNameMessage;
        emailError = emailMessage;
        _passwordError = passwordMessage;
      });
    } else {
      AppSnackBar.show(context, error.message, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: _onState,
      builder: (context, state) {
        final isLoading = state is AuthLoading;
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
                      errorText: firstNameError,
                      onChanged: (_) {
                        if (firstNameError != null) {
                          setState(() => firstNameError = null);
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: lastName,
                      labelText: 'Last Name',
                      hintText: 'Vane',
                      errorText: lastNameError,
                      onChanged: (_) {
                        if (lastNameError != null) {
                          setState(() => lastNameError = null);
                        }
                      },
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
                errorText: emailError,
                onChanged: (_) {
                  if (emailError != null) setState(() => emailError = null);
                },
              ),
              SizedBox(height: 16),
              PasswordTextField(
                controller: password,
                hintText: '•••••••••••••',
                errorText: _passwordError,
                helperText: _passwordError == null
                    ? 'At least 1 uppercase letter and 1 special character'
                    : null,
                onChanged: (_) {
                  if (_passwordError != null) {
                    setState(() => _passwordError = null);
                  }
                },
              ),
              SizedBox(height: 24),
              AuthButton(
                text: 'Sign Up',
                isLoading: isLoading,
                onPressed: _submit,
              ),
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
      },
    );
  }
}
