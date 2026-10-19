import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';

class ProductGrid extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ScrollController? controller;
  final bool isLoadingMore;

  const ProductGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.isLoadingMore = false,
  });

  static const double staticPadding = 24;
  static const double staticSpacing = 12;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - staticPadding * 2 - staticSpacing) / 2;

        return CustomScrollView(
          controller: controller,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(staticPadding, 8, staticPadding, 24),
              sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: staticSpacing,
                  mainAxisSpacing: staticSpacing,
                  mainAxisExtent: itemWidth + 88,
                ),
                itemCount: itemCount,
                itemBuilder: itemBuilder,
              ),
            ),
            if (isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.gold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}