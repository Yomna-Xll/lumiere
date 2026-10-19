import 'package:flutter/material.dart';
import 'package:lumiere/core/utils/validators.dart';
import 'package:lumiere/core/widgets/auth/auth_button.dart';
import 'package:lumiere/core/widgets/auth/auth_header.dart';
import 'package:lumiere/core/widgets/auth/auth_scaffold.dart';
import 'package:lumiere/core/widgets/auth/custom_text_field.dart';
import 'package:lumiere/features/auth/ui/reset_code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail = ''});
  final String initialEmail;

  @override
  State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController email;
  String? emailError;
  bool isLoading = false;

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

  Future<void> sendCode() async {
    final value = email.text.trim();
    final error = Validators.email(value);
    if (error != null) {
      setState(() => emailError = error);
      return;
    }
    setState(() {
      emailError = null;
      isLoading = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ResetCodeScreen(email: value)),
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
            onPressed: sendCode,
          ),
        ],
      ),
    );
  }
}
