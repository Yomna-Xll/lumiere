import 'package:lumiere/core/network/paged_result.dart';
import 'package:lumiere/features/products/data/models/product_model.dart';

abstract class ProductsRepository {
  Future<PagedResult<ProductModel>> getProducts({
    required int page,
    required int pageSize,
    String? category,
    String? searchTerm,
  });
  Future<void> deleteProduct(String id);
}