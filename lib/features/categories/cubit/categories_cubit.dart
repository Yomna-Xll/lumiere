// features/categories/cubit/categories_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/network/api_error.dart';
import 'package:lumiere/features/categories/data/categories_repository.dart';
import 'package:lumiere/features/categories/data/category_model.dart';

enum CategoriesStatus { loading, data, error }

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final List<CategoryModel> items;

  const CategoriesState({
    this.status = CategoriesStatus.loading,
    this.items = const [],
  });

  @override
  List<Object?> get props => [status, items.length];
}

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this._repo) : super( CategoriesState());

  final CategoriesRepository _repo;

  Future<void> load() async {
    emit( CategoriesState());
    try {
      final items = await _repo.getCategories();
      emit(CategoriesState(status: CategoriesStatus.data, items: items));
    } on ApiError {
      emit( CategoriesState(status: CategoriesStatus.error));
    }
  }
}