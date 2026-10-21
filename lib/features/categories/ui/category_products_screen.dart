import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/utils/formatters.dart';
import 'package:lumiere/core/widgets/products/products_view.dart';
import 'package:lumiere/features/categories/data/category_model.dart';
import 'package:lumiere/features/products/cubit/products_cubit.dart';
import 'package:lumiere/features/products/data/products_repository.dart';

class CategoryProductsScreen extends StatelessWidget {
  final CategoryModel category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit(
        context.read<ProductsRepository>(),
        category: category.name, 
      )..load(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundAlt,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundAlt,
          title: Text(Formatters.capitalize(category.name)),
        ),
        body: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) => ProductsView(
            state: state,
            onReload: () => context.read<ProductsCubit>().load(),
            onLoadMore: () => context.read<ProductsCubit>().loadMore(),
          ),
        ),
      ),
    );
  }
}