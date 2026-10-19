import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_theme.dart';
import 'package:lumiere/features/auth/ui/login_screen.dart';
import 'package:lumiere/features/main_ui/home_screen.dart';
import 'package:lumiere/features/main_ui/main_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: Scaffold(body: MainShell()),
    );
  }
}
