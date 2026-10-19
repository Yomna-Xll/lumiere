import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/utils/formatters.dart';
import 'package:lumiere/core/widgets/products/product_card.dart';
import 'package:lumiere/core/widgets/products/product_grid.dart';
import 'package:lumiere/core/widgets/state_view.dart';
import 'package:lumiere/features/products/ui/product_details_screen.dart';
import 'package:lumiere/sample_products.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final products =
        sampleProducts.where((p) => p.categories.contains(category)).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundAlt,
        title: Text(Formatters.capitalize(category)),
      ),
      body: products.isEmpty
          ?  StateView(
              icon: Icons.diamond_outlined,
              title: 'No products found',
            )
          : ProductGrid(
              itemCount: products.length,
              itemBuilder: (_, i) {
                final product = products[i];
                return ProductCard(
                  product: product,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(product: product),
                    ),
                  ),
                );
              },
            ),
    );
  }
}