import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/theme/app_text_style.dart';

class DiscountBadge extends StatelessWidget {
  final double percentage;

  const DiscountBadge({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Badge(text: '-${percentage.round()}%', color: AppColors.goldDark);
  }
}

class SoldOutBadge extends StatelessWidget {
  const SoldOutBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Badge(text: 'Sold out', color: AppColors.textSecondary);
  }
}

class Badge extends StatelessWidget {
  final String text;
  final Color color;

  const Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: AppTextStyle.badge.copyWith(color: Colors.white)),
    );
  }
}