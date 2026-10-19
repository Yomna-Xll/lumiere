import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/theme/app_text_style.dart';
import 'package:lumiere/core/widgets/products/app_network_image.dart';
import 'package:lumiere/core/widgets/products/price_row.dart';
import 'package:lumiere/core/widgets/products/product_badges.dart';
import 'package:lumiere/features/products/data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final soldOut = product.isSoldOut;
    final fade = soldOut ? 0.5 : 1.0;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Opacity(
                      opacity: fade,
                      child: AppNetworkImage(
                        url: product.coverPictureUrl,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: soldOut
                          ? const SoldOutBadge()
                          : (product.hasDiscount
                              ? DiscountBadge(
                                  percentage: product.discountPercentage,
                                )
                              : const SizedBox.shrink()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Opacity(
                opacity: fade,
                child: Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodyMedium,
                ),
              ),
              const Spacer(),
              Opacity(
                opacity: fade,
                child: PriceRow(
                  price: product.finalPrice,
                  oldPrice: product.hasDiscount ? product.price : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}