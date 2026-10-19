import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/widgets/auth/auth_button.dart';
import 'package:lumiere/core/widgets/auth/auth_header.dart';
import 'package:lumiere/core/widgets/auth/auth_scaffold.dart';
import 'package:lumiere/features/auth/ui/login_screen.dart';

class PasswordUpdatedScreen extends StatelessWidget {
  const PasswordUpdatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.success, width: 2),
              ),
              child: Icon(Icons.check, color: AppColors.success, size: 32),
            ),
            SizedBox(height: 24),
            AuthHeader(
              title: 'Password updated',
              subtitle: 'Your password has been changed successfully',
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            SizedBox(height: 32),
            AuthButton(
              text: 'Back to login',
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
