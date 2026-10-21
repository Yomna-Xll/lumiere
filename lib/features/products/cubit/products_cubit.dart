// features/products/cubit/products_cubit.dart
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/network/api_error.dart';
import 'package:lumiere/features/products/data/models/product_model.dart';
import 'package:lumiere/features/products/data/products_repository.dart';

enum ProductsStatus { idle, loading, data, empty, error, noInternet }

class ProductsState extends Equatable {
  final ProductsStatus status;
  final List<ProductModel> items;
  final bool hasNext;
  final bool isLoadingMore;

  const ProductsState({
    this.status = ProductsStatus.loading,
    this.items = const [],
    this.hasNext = false,
    this.isLoadingMore = false,
  });

  ProductsState copyWith({bool? isLoadingMore}) => ProductsState(
    status: status,
    items: items,
    hasNext: hasNext,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );

  @override
  List<Object?> get props => [status, items, hasNext, isLoadingMore];
}

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this.repo, {this.category, bool startIdle = false})
    : super(
        ProductsState(
          status: startIdle ? ProductsStatus.idle : ProductsStatus.loading,
        ),
      );

  static const pageSize = 10;

  final ProductsRepository repo;
  final String? category;

  String? searchTerm;
  int _page = 1;
  int _requestId = 0;
  Timer? _debounce;

  Future<void> load() async {
    emit(ProductsState());
    await _fetch(page: 1);
  }

  Future<void> loadMore() async {
    if (state.status != ProductsStatus.data ||
        !state.hasNext ||
        state.isLoadingMore) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    await _fetch(page: _page + 1);
  }

  void search(String query) {
    _debounce?.cancel();
    final term = query.trim();
    if (term.isEmpty) {
      _requestId++;
      searchTerm = null;
      emit(ProductsState(status: ProductsStatus.idle));
      return;
    }
    _debounce = Timer(Duration(milliseconds: 400), () {
      searchTerm = term;
      load();
    });
  }

  Future<void> _fetch({required int page}) async {
    final id = ++_requestId;
    try {
      final result = await repo.getProducts(
        page: page,
        pageSize: pageSize,
        category: category,
        searchTerm: searchTerm,
      );
      if (id != _requestId || isClosed) return;

      _page = result.page;
      final all = page == 1 ? result.items : [...state.items, ...result.items];
      emit(
        ProductsState(
          status: all.isEmpty ? ProductsStatus.empty : ProductsStatus.data,
          items: all,
          hasNext: result.hasNextPage,
        ),
      );
    } on ApiError catch (e) {
      if (id != _requestId || isClosed) return;
      if (page > 1) {
        emit(state.copyWith(isLoadingMore: false));
        return;
      }
      emit(
        ProductsState(
          status: e.isNetworkError
              ? ProductsStatus.noInternet
              : ProductsStatus.error,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
