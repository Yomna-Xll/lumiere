import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/utils/validators.dart';
import 'package:lumiere/core/widgets/auth/auth_button.dart';
import 'package:lumiere/core/widgets/auth/auth_header.dart';
import 'package:lumiere/core/widgets/auth/auth_scaffold.dart';
import 'package:lumiere/core/widgets/auth/custom_text_field.dart';
import 'package:lumiere/core/widgets/auth/snack_bar.dart';

import 'package:lumiere/features/auth/cubit/auth_cubit.dart';
import 'package:lumiere/features/auth/cubit/auth_state.dart';
import 'package:lumiere/features/auth/data/auth_repository.dart';
import 'package:lumiere/features/auth/ui/reset_code_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(context.read<AuthRepository>()),
      child: ForgotPasswordView(initialEmail: initialEmail),
    );
  }
}

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({required this.initialEmail});

  final String initialEmail;

  @override
  State<ForgotPasswordView> createState() => ForgotPasswordViewState();
}

class ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController email;
  String? emailError;

  @override
  void initState() {
    super.initState();
    email = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  void submit() {
    final error = Validators.email(email.text);
    setState(() => emailError = error);
    if (error != null) return;
    context.read<AuthCubit>().forgotPassword(email.text.trim());
  }

  void onState(BuildContext context, AuthState state) {
    if (state is AuthSuccess && state.action == AuthAction.forgotPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetCodeScreen(email: email.text.trim()),
        ),
      );
      return;
    }
    if (state is! AuthFailure) return;

    final emailMessage = state.error.fieldError('email');
    if (emailMessage != null) {
      setState(() => emailError = emailMessage);
    } else {
      AppSnackBar.show(context, state.error.message, isError: true);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHeader(
                title: 'Forgot password?',
                subtitle: "Enter your email and we'll send you a code",
              ),
              SizedBox(height: 24),
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
              SizedBox(height: 24),
              AuthButton(
                text: 'Send code',
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
