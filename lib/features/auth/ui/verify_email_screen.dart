import 'package:flutter/material.dart';
import 'package:lumiere/core/widgets/auth_button.dart';
import 'package:lumiere/core/widgets/auth_header.dart';
import 'package:lumiere/core/widgets/auth_scaffold.dart';
import 'package:lumiere/core/widgets/otp_boxes.dart';
import 'package:lumiere/core/widgets/resend_timer.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, required this.email});
  final String email;

  @override
  State<VerifyEmailScreen> createState() => VerifyEmailScreenState();
}

class VerifyEmailScreenState extends State<VerifyEmailScreen> {
  String code = '';
  String? errorText;
  bool isLoading = false;

  Future<void> verify() async {
    if (code.length < 6) {
      setState(() => errorText = 'Invalid code, please try again.');
      return;
    }
    setState(() {
      errorText = null;
      isLoading = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            onChanged: (v) => setState(() {
              code = v;
              errorText = null;
            }),
          ),
          SizedBox(height: 24),
          AuthButton(text: 'Verify', isLoading: isLoading, onPressed: verify),
          SizedBox(height: 24),
          ResendTimer(onResend: () {}),
        ],
      ),
    );
  }
}
