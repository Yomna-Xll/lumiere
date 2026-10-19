import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_text_style.dart';
import 'package:lumiere/core/utils/formatters.dart';
import 'package:lumiere/core/widgets/auth/app_logo.dart';
import 'package:lumiere/core/widgets/category/category_chip.dart';
import 'package:lumiere/core/widgets/product_skeletons.dart';
import 'package:lumiere/core/widgets/products/product_card.dart';
import 'package:lumiere/core/widgets/products/product_grid.dart';
import 'package:lumiere/core/widgets/state_view.dart';
import 'package:lumiere/features/categories/ui/category_products_screen.dart';
import 'package:lumiere/features/products/data/models/product_model.dart';
import 'package:lumiere/features/products/ui/product_details_screen.dart';
import 'package:lumiere/sample_products.dart';

enum HomeStatus { loading, error, empty, noInternet, data }

class HomeScreen extends StatefulWidget {
  final VoidCallback onSearchTap;

  const HomeScreen({super.key, required this.onSearchTap});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final HomeStatus status = HomeStatus.data;

  static const categories = [
    'charms',
    'jewelry',
    'anklets',
    'pendants',
    'brooches',
    'bracelets',
  ];

  void openDetails(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(product: product),
      ),
    );
  }

  void openCategory(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryProductsScreen(category: category),
      ),
    );
  }

  Widget buildContent() {
    return switch (status) {
      HomeStatus.loading => ProductGrid(
          itemCount: 6,
          itemBuilder: (_, _) => const ProductCardSkeleton(),
        ),
      HomeStatus.error => StateView(
          icon: Icons.error_outline,
          title: 'Something went wrong',
          actionText: 'Retry',
          onAction: () {},
        ),
      HomeStatus.empty => const StateView(
          icon: Icons.diamond_outlined,
          title: 'No products found',
        ),
      HomeStatus.noInternet => StateView(
          icon: Icons.wifi_off,
          title: 'No internet connection',
          actionText: 'Retry',
          onAction: () {},
        ),
      HomeStatus.data => ProductGrid(
          itemCount: sampleProducts.length,
          itemBuilder: (_, i) {
            final product = sampleProducts[i];
            return ProductCard(
              product: product,
              onTap: () => openDetails(product),
            );
          },
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             AppLogo(width: 28, height: 28),
             SizedBox(width: 8),
            Text('LUMIÈRE', style: AppTextStyle.wordmark),
          ],
        ),
        actions: [
          IconButton(
            icon:  Icon(Icons.search),
            onPressed: widget.onSearchTap,
          ),
           SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
           SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: categories.length + 1,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                if (i == 0) {
                  return  CategoryChip(label: 'All', selected: true);
                }
                final category = categories[i - 1];
                return CategoryChip(
                  label: Formatters.capitalize(category),
                  onTap: () => openCategory(category),
                );
              },
            ),
          ),
           SizedBox(height: 8),
          Expanded(child: buildContent()),
        ],
      ),
    );
  }
}