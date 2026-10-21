// features/products/cubit/delete_product_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/network/api_error.dart';
import 'package:lumiere/features/products/data/products_repository.dart';

sealed class DeleteProductState extends Equatable {
  const DeleteProductState();

  @override
  List<Object?> get props => [];
}

class DeleteInitial extends DeleteProductState {
  const DeleteInitial();
}

class DeleteLoading extends DeleteProductState {
  const DeleteLoading();
}

class DeleteSuccess extends DeleteProductState {
  const DeleteSuccess();
}

class DeleteFailure extends DeleteProductState {
  final ApiError error;
  const DeleteFailure(this.error);

  @override
  List<Object?> get props => [error.message, error.statusCode];
}

class DeleteProductCubit extends Cubit<DeleteProductState> {
  DeleteProductCubit(this.repo) : super(const DeleteInitial());

  final ProductsRepository repo;

  Future<void> delete(String id) async {
    emit(const DeleteLoading());
    try {
      await repo.deleteProduct(id);
      if (isClosed) return;
      emit(const DeleteSuccess());
    } on ApiError catch (e) {
      if (isClosed) return;
      emit(DeleteFailure(e));
    }
  }
}