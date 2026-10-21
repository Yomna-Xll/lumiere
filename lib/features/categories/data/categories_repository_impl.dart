import 'package:dio/dio.dart';
import 'package:lumiere/core/network/api_constants.dart';
import 'package:lumiere/core/network/guard_api.dart';
import 'package:lumiere/features/categories/data/categories_repository.dart';
import 'package:lumiere/features/categories/data/category_model.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  CategoriesRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<CategoryModel>> getCategories() => guardApi(() async {
    final res = await _dio.get(ApiConstants.categories);
    final data = res.data;
    final list = data is List ? data : (data['categories'] as List<dynamic>);
    return list
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  });
}
