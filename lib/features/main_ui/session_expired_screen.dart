import 'package:flutter/material.dart';
import 'package:lumiere/core/widgets/state_view.dart';
import 'package:lumiere/features/auth/ui/login_screen.dart';

class SessionExpiredScreen extends StatelessWidget {
  const SessionExpiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StateView(
        icon: Icons.lock_outline,
        title: 'Session expired',
        subtitle: 'Please log in again to continue',
        actionText: 'Go to login',
        onAction: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) =>  LoginScreen()),
          (route) => false,
        ),
      ),
    );
  }
}