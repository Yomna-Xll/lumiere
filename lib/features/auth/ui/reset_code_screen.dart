import 'package:flutter/material.dart';
import 'package:lumiere/core/widgets/auth_button.dart';
import 'package:lumiere/core/widgets/auth_header.dart';
import 'package:lumiere/core/widgets/auth_scaffold.dart';
import 'package:lumiere/core/widgets/otp_boxes.dart';
import 'package:lumiere/core/widgets/resend_timer.dart';
import 'package:lumiere/features/auth/ui/reset_password_screen.dart';


class ResetCodeScreen extends StatefulWidget {
  const ResetCodeScreen({super.key, required this.email});
  final String email;

  @override
  State<ResetCodeScreen> createState() => ResetCodeScreenState();
}

class ResetCodeScreenState extends State<ResetCodeScreen> {
  String code = '';
  String? errorText;

  void _continue() {
    if (code.length < 6) {
      setState(() => errorText = 'Invalid code, please try again.');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResetPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            onChanged: (v) => setState(() {
              code = v;
              errorText = null;
            }),
          ),
          SizedBox(height: 24),
          AuthButton(text: 'Continue', onPressed: _continue),
          SizedBox(height: 16),
          ResendTimer(onResend: () {}),
        ],
      ),
    );
  }
}
