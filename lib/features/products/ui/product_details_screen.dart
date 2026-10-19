import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/theme/app_text_style.dart';
import 'package:lumiere/core/utils/formatters.dart';
import 'package:lumiere/core/widgets/auth/snack_bar.dart';
import 'package:lumiere/core/widgets/category/category_chip.dart';
import 'package:lumiere/core/widgets/confirm_dialog.dart';
import 'package:lumiere/core/widgets/info_row.dart';
import 'package:lumiere/core/widgets/products/app_network_image.dart';
import 'package:lumiere/core/widgets/products/price_row.dart';
import 'package:lumiere/core/widgets/products/product_badges.dart';
import 'package:lumiere/features/products/data/models/product_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  Future<void> delete(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context,
      icon: Icons.warning_amber_rounded,
      title: 'Delete product?',
      message: 'This action cannot be undone.',
      confirmText: 'Delete',
      confirmColor: AppColors.error,
    );
    if (!confirmed || !context.mounted) return;

    AppSnackBar.show(context, 'Product deleted');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: AppNetworkImage(url: product.coverPictureUrl),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleButton(
                            icon: Icons.arrow_back,
                            onTap: () => Navigator.pop(context),
                          ),
                          CircleButton(
                            icon: Icons.delete_outline,
                            onTap: () => delete(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: AppTextStyle.headingLarge),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      PriceRow(
                        price: product.finalPrice,
                        oldPrice: product.hasDiscount ? product.price : null,
                        large: true,
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 8),
                        DiscountBadge(percentage: product.discountPercentage),
                      ],
                    ],
                  ),
                  if (product.isSoldOut) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Out of stock',
                      style: AppTextStyle.helper.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ] else if (product.isLowStock) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Only ${product.stock} left',
                      style: AppTextStyle.helper.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final category in product.categories)
                        CategoryChip(label: Formatters.capitalize(category)),
                    ],
                  ),
                  if (product.description.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Description', style: AppTextStyle.headingMedium),
                    const SizedBox(height: 8),
                    Text(product.description, style: AppTextStyle.body),
                  ],
                  const SizedBox(height: 24),
                  const Divider(color: AppColors.inputFill),
                  InfoRow(label: 'Color', value: product.color),
                  InfoRow(
                    label: 'Weight',
                    value: '${Formatters.number(product.weight)}g',
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

class CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}