import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/widgets/app_search_field.dart';
import 'package:lumiere/core/widgets/products/products_view.dart';
import 'package:lumiere/core/widgets/state_view.dart';
import 'package:lumiere/features/products/cubit/products_cubit.dart';
import 'package:lumiere/features/products/data/products_repository.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductsCubit(context.read<ProductsRepository>(), startIdle: true),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView();

  @override
  State<SearchView> createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();
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
              onChanged: cubit.search,
              onClear: () => cubit.search(''),
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state.status == ProductsStatus.idle) {
                  return  StateView(
                    icon: Icons.search,
                    title: 'Search our collection',
                    subtitle: 'Find jewelry, charms and more',
                  );
                }
                return ProductsView(
                  state: state,
                  emptyTitle: 'No results for your search',
                  onReload: () => cubit.search(controller.text),
                  onLoadMore: cubit.loadMore,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}