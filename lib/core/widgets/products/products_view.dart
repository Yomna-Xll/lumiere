import 'package:flutter/material.dart';
import 'package:lumiere/core/widgets/product_skeletons.dart';
import 'package:lumiere/core/widgets/products/product_card.dart';
import 'package:lumiere/core/widgets/products/product_grid.dart';
import 'package:lumiere/core/widgets/state_view.dart';
import 'package:lumiere/features/products/cubit/products_cubit.dart';
import 'package:lumiere/features/products/data/models/product_model.dart';
import 'package:lumiere/features/products/ui/product_details_screen.dart';

class ProductsView extends StatefulWidget {
  final ProductsState state;
  final VoidCallback onReload;
  final VoidCallback onLoadMore;
  final String emptyTitle;

  const ProductsView({
    super.key,
    required this.state,
    required this.onReload,
    required this.onLoadMore,
    this.emptyTitle = 'No products found',
  });

  @override
  State<ProductsView> createState() => ProductsViewState();
}

class ProductsViewState extends State<ProductsView> {
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    if (controller.hasClients && controller.position.extentAfter < 300) {
      widget.onLoadMore();
    }
  }

  Future<void> open(ProductModel product) async {
    final deleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
    );
    if (deleted == true && mounted) widget.onReload();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    switch (state.status) {
      case ProductsStatus.idle:
        return const SizedBox.shrink();
      case ProductsStatus.loading:
        return ProductGrid(
          itemCount: 6,
          itemBuilder: (_, _) => const ProductCardSkeleton(),
        );
      case ProductsStatus.error:
        return StateView(
          icon: Icons.error_outline,
          title: 'Something went wrong',
          actionText: 'Retry',
          onAction: widget.onReload,
        );
      case ProductsStatus.noInternet:
        return StateView(
          icon: Icons.wifi_off,
          title: 'No internet connection',
          actionText: 'Retry',
          onAction: widget.onReload,
        );
      case ProductsStatus.empty:
        return StateView(icon: Icons.diamond_outlined, title: widget.emptyTitle);
      case ProductsStatus.data:
        return ProductGrid(
          controller: controller,
          isLoadingMore: state.isLoadingMore,
          itemCount: state.items.length,
          itemBuilder: (_, i) {
            final product = state.items[i];
            return ProductCard(product: product, onTap: () => open(product));
          },
        );
    }
  }
}