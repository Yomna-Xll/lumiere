import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_text_style.dart';
import 'package:lumiere/core/theme/app_theme.dart';
import 'package:lumiere/features/theme_test_screen.dart';

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
      home: Scaffold(body: ThemeTestScreen()),
    );
  }
}
