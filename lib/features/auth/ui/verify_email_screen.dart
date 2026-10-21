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

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({
    super.key,
    required this.email,
    this.resendOnOpen = false,
  });

  final String email;
  final bool resendOnOpen;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(context.read<AuthRepository>()),
      child: VerifyView(email: email, resendOnOpen: resendOnOpen),
    );
  }
}

class VerifyView extends StatefulWidget {
  const VerifyView({required this.email, required this.resendOnOpen});

  final String email;
  final bool resendOnOpen;

  @override
  State<VerifyView> createState() => VerifyViewState();
}

class VerifyViewState extends State<VerifyView> {
  String code = '';
  String? errorText;

  @override
  void initState() {
    super.initState();
    if (widget.resendOnOpen) {
      context.read<AuthCubit>().resendOtp(widget.email);
    }
  }

  void verify() {
    if (code.length < 6) {
      setState(() => errorText = 'Please enter the 6-digit code.');
      return;
    }
    context.read<AuthCubit>().verifyEmail(widget.email, code);
  }

  void onState(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      if (state.action == AuthAction.verifyEmail) {
        AppSnackBar.show(context, 'Email verified, please log in');
        Navigator.popUntil(context, (route) => route.isFirst);
      } else if (state.action == AuthAction.resendOtp) {
        AppSnackBar.show(context, 'A new code was sent to your email');
      }
    } else if (state is AuthFailure) {
      if (state.action == AuthAction.verifyEmail) {
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
        final verifying =
            state is AuthLoading && state.action == AuthAction.verifyEmail;
        return AuthScaffold(
          showBackButton: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHeader(
                title: 'Verify your email',
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
                text: 'Verify',
                isLoading: verifying,
                onPressed: verify,
              ),
              SizedBox(height: 24),
              ResendTimer(
                onResend: () =>
                    context.read<AuthCubit>().resendOtp(widget.email),
              ),
            ],
          ),
        );
      },
    );
  }
}
