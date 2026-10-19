import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/widgets/app_search_field.dart';
import 'package:lumiere/core/widgets/products/product_card.dart';
import 'package:lumiere/core/widgets/products/product_grid.dart';
import 'package:lumiere/core/widgets/state_view.dart';
import 'package:lumiere/features/products/data/models/product_model.dart';
import 'package:lumiere/features/products/ui/product_details_screen.dart';
import 'package:lumiere/sample_products.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  String query = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<ProductModel> get results {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return sampleProducts
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();
  }

  Widget buildBody() {
    if (query.trim().isEmpty) {
      return  StateView(
        icon: Icons.search,
        title: 'Search our collection',
        subtitle: 'Find jewelry, charms and more',
      );
    }
    final results = this.results;
    if (results.isEmpty) {
      return  StateView(
        icon: Icons.search_off,
        title: 'No results for your search',
      );
    }
    return ProductGrid(
      itemCount: results.length,
      itemBuilder: (_, i) {
        final product = results[i];
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundAlt,
        title:  Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: AppSearchField(
              controller: controller,
              onChanged: (value) => setState(() => query = value),
              onClear: () => setState(() => query = ''),
            ),
          ),
          Expanded(child: buildBody()),
        ],
      ),
    );
  }
}