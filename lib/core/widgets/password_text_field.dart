import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/widgets/custom_text_field.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final String? errorText;
  final String? helperText;
  final ValueChanged<String>? onChanged;

  const PasswordTextField({
    super.key,
    this.controller,
    this.labelText = 'Password',
    this.hintText = '••••••••',
    this.errorText,
    this.helperText,
    this.onChanged,
  });

  @override
  State<PasswordTextField> createState() => PasswordTextFieldState();
}

class PasswordTextFieldState extends State<PasswordTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      errorText: widget.errorText,
      helperText: widget.helperText,
      obscureText: obscureText,
      keyboardType: TextInputType.visiblePassword,
      onChanged: widget.onChanged,
      suffixIcon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.textSecondary,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            obscureText = !obscureText;
          });
        },
      ),
    );
  }
}