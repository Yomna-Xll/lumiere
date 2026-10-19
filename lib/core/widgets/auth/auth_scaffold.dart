import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/theme/app_text_style.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final bool showBackButton;
  final String? title;
  final VoidCallback? onBackTap;

  const AuthScaffold({
    super.key,
    required this.child,
    this.showBackButton = false,
    this.title,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (showBackButton || title != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    if (showBackButton)
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                        color: AppColors.textPrimary,
                        onPressed: onBackTap ?? () => Navigator.maybePop(context),
                      ),
                    if (title != null) ...[
                      if (showBackButton) const SizedBox(width: 8),
                      Text(
                        title!,
                        style: AppTextStyle.headingMedium,
                      ),
                    ],
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}