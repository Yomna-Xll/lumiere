import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/theme/app_text_style.dart';
import 'package:lumiere/core/widgets/confirm_dialog.dart';
import 'package:lumiere/features/auth/ui/change_password_screen.dart';
import 'package:lumiere/features/auth/ui/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> logout(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context,
      icon: Icons.logout,
      title: 'Log out?',
      message: 'Are you sure you want to log out?',
      confirmText: 'Log out',
      confirmColor: AppColors.textPrimary,
    );
    if (!confirmed || !context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
             SizedBox(height: 24),
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.inputFill,
              child: Text(
                'YE',
                style: AppTextStyle.headingMedium.copyWith(
                  color: AppColors.gold,
                ),
              ),
            ),
             SizedBox(height: 16),
            Text('Yomna Ebrahim', style: AppTextStyle.headingMedium),
             SizedBox(height: 4),
            Text('yomna.ebrahim@example.com', style: AppTextStyle.body),
             SizedBox(height: 32),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Change password',
                      style: AppTextStyle.bodyMedium,
                    ),
                    trailing:  Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>  ChangePasswordScreen(),
                      ),
                    ),
                  ),
                   Divider(height: 1, color: AppColors.inputFill),
                  ListTile(
                    title: Text(
                      'Log out',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                    onTap: () => logout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
