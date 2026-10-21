import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/theme/app_text_style.dart';
import 'package:lumiere/core/utils/formatters.dart';
import 'package:lumiere/core/widgets/auth/app_logo.dart';
import 'package:lumiere/core/widgets/category/category_chip.dart';
import 'package:lumiere/core/widgets/products/products_view.dart';
import 'package:lumiere/features/categories/cubit/categories_cubit.dart';
import 'package:lumiere/features/categories/data/categories_repository.dart';
import 'package:lumiere/features/categories/ui/category_products_screen.dart';
import 'package:lumiere/features/products/cubit/products_cubit.dart';
import 'package:lumiere/features/products/data/products_repository.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onSearchTap;

  const HomeScreen({super.key, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProductsCubit(context.read<ProductsRepository>())..load(),
        ),
        BlocProvider(
          create: (context) =>
              CategoriesCubit(context.read<CategoriesRepository>())..load(),
        ),
      ],
      child: Scaffold(
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
            IconButton(icon: const Icon(Icons.search), onPressed: onSearchTap),
            SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 8),
            CategoryChips(),
            SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) => ProductsView(
                  state: state,
                  onReload: () => context.read<ProductsCubit>().load(),
                  onLoadMore: () => context.read<ProductsCubit>().loadMore(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryChips extends StatelessWidget {
  const CategoryChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        final categories = state.items;
        return SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: categories.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              if (i == 0)
                return const CategoryChip(label: 'All', selected: true);
              final category = categories[i - 1];
              return CategoryChip(
                label: Formatters.capitalize(category.name),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryProductsScreen(category: category),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
