
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_style.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.background,

      colorScheme: ColorScheme.light(
        primary: AppColors.textPrimary,
        secondary: AppColors.gold,
        error: AppColors.error,
        surface: AppColors.surface,
      ),

      textTheme: TextTheme(
        headlineLarge: AppTextStyle.headingLarge,
        titleLarge: AppTextStyle.headingMedium,
        titleSmall: AppTextStyle.bodyMedium,
        bodyLarge: AppTextStyle.inputText,
        bodyMedium: AppTextStyle.body.copyWith(
          color: AppColors.textPrimary,
        ),
        bodySmall: AppTextStyle.helper,
        labelLarge: AppTextStyle.button,
        labelSmall: AppTextStyle.navLabel,
      ),
    );
  }
}
