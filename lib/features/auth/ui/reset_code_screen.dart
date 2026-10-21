import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/widgets/auth/auth_button.dart';
import 'package:lumiere/core/widgets/auth/auth_header.dart';
import 'package:lumiere/core/widgets/auth/auth_scaffold.dart';
import 'package:lumiere/core/widgets/auth/otp_boxes.dart';
import 'package:lumiere/core/widgets/auth/resend_timer.dart';
import 'package:lumiere/core/widgets/auth/snack_bar.dart';
import 'package:lumiere/features/auth/cubit/auth_cubit.dart';
import 'package:lumiere/features/auth/cubit/auth_state.dart';
import 'package:lumiere/features/auth/data/auth_repository.dart';
import 'package:lumiere/features/auth/ui/reset_password_screen.dart';

class ResetCodeScreen extends StatelessWidget {
  const ResetCodeScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(context.read<AuthRepository>()),
      child: ResetCodeView(email: email),
    );
  }
}

class ResetCodeView extends StatefulWidget {
  const ResetCodeView({required this.email});

  final String email;

  @override
  State<ResetCodeView> createState() => ResetCodeViewState();
}

class ResetCodeViewState extends State<ResetCodeView> {
  String code = '';
  String? errorText;

  void submit() {
    if (code.length < 6) {
      setState(() => errorText = 'Please enter the 6-digit code.');
      return;
    }
    context.read<AuthCubit>().validateOtp(widget.email, code);
  }

  void onState(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      if (state.action == AuthAction.validateOtp) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(email: widget.email, otp: code),
          ),
        );
      } else if (state.action == AuthAction.forgotPassword) {
        AppSnackBar.show(context, 'A new code was sent to your email');
      }
    } else if (state is AuthFailure) {
      if (state.action == AuthAction.validateOtp) {
        setState(
          () =>
              errorText = state.error.fieldError('otp') ?? state.error.message,
        );
      } else {
        AppSnackBar.show(context, state.error.message, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: onState,
      builder: (context, state) {
        final isLoading =
            state is AuthLoading && state.action == AuthAction.validateOtp;
        return AuthScaffold(
          showBackButton: true,
          title: 'Reset Code',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHeader(
                title: 'Enter reset code',
                subtitle: 'We sent a 6-digit code to ${widget.email}',
              ),
              SizedBox(height: 24),
              OtpBoxes(
                errorText: errorText,
                onChanged: (value) => setState(() {
                  code = value;
                  errorText = null;
                }),
              ),
              SizedBox(height: 24),
              AuthButton(
                text: 'Continue',
                isLoading: isLoading,
                onPressed: submit,
              ),
              SizedBox(height: 16),
              ResendTimer(
                onResend: () =>
                    context.read<AuthCubit>().forgotPassword(widget.email),
              ),
            ],
          ),
        );
      },
    );
  }
}
