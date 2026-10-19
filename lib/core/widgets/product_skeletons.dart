import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/widgets/skeleton_box.dart';

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(aspectRatio: 1, child: SkeletonBox(radius: 12)),
          SizedBox(height: 8),
          SkeletonBox(height: 14),
          SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: SkeletonBox(width: 80, height: 14),
          ),
          Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: SkeletonBox(width: 64, height: 18),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsSkeleton extends StatelessWidget {
  const ProductDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(aspectRatio: 1, child: SkeletonBox(radius: 0)),
        Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 220, height: 28),
              SizedBox(height: 12),
              SkeletonBox(width: 140, height: 24),
              SizedBox(height: 16),
              Row(
                children: [
                  SkeletonBox(width: 90, height: 36, radius: 18),
                  SizedBox(width: 8),
                  SkeletonBox(width: 90, height: 36, radius: 18),
                ],
              ),
              SizedBox(height: 24),
              SkeletonBox(width: 120, height: 20),
              SizedBox(height: 12),
              SkeletonBox(height: 14),
              SizedBox(height: 8),
              SkeletonBox(height: 14),
              SizedBox(height: 8),
              SkeletonBox(width: 200, height: 14),
            ],
          ),
        ),
      ],
    );
  }
}