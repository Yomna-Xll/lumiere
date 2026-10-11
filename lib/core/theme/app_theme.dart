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
        bodyMedium: AppTextStyle.body.copyWith(color: AppColors.textPrimary),
        bodySmall: AppTextStyle.helper,
        labelLarge: AppTextStyle.button,
        labelSmall: AppTextStyle.navLabel,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        labelStyle: AppTextStyle.inputLabel,

        hintStyle: AppTextStyle.inputText.copyWith(color: AppColors.textHint),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        errorStyle: AppTextStyle.helper.copyWith(color: AppColors.error),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.textPrimary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyle.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.gold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyle.button.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
