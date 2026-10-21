import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/theme/app_text_style.dart';
import 'package:lumiere/core/widgets/confirm_dialog.dart';
import 'package:lumiere/features/auth/cubit/session_cubit.dart';
import 'package:lumiere/features/auth/cubit/session_state.dart';
import 'package:lumiere/features/auth/ui/change_password_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context,
      icon: Icons.logout,
      title: 'Log out?',
      message: 'Are you sure you want to log out?',
      confirmText: 'Log out',
      confirmColor: AppColors.textPrimary,
    );
    if (!confirmed || !context.mounted) return;
    context.read<SessionCubit>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final user = session is SessionAuthenticated ? session.user : null;

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
                user?.initials ?? '',
                style: AppTextStyle.headingMedium.copyWith(
                  color: AppColors.gold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(user?.fullName ?? '', style: AppTextStyle.headingMedium),
            SizedBox(height: 4),
            Text(user?.email ?? '', style: AppTextStyle.body),
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
                    trailing: Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
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
                    onTap: () => _logout(context),
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
