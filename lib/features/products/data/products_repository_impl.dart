import 'package:dio/dio.dart';
import 'package:lumiere/core/network/api_constants.dart';
import 'package:lumiere/core/network/guard_api.dart';
import 'package:lumiere/core/network/paged_result.dart';
import 'package:lumiere/features/products/data/models/product_model.dart';
import 'package:lumiere/features/products/data/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<PagedResult<ProductModel>> getProducts({
    required int page,
    required int pageSize,
    String? category,
    String? searchTerm,
  }) =>
      guardApi(() async {
        final res = await dio.get(
          ApiConstants.products,
          queryParameters: {
            'page': page,
            'pageSize': pageSize,
            if (category != null) 'category': category,
            if (searchTerm != null) 'searchTerm': searchTerm,
          },
        );
        return PagedResult.fromJson(
            res.data as Map<String, dynamic>, ProductModel.fromJson);
      });

  @override
  Future<void> deleteProduct(String id) =>
      guardApi(() => dio.delete('${ApiConstants.products}/$id'));
}