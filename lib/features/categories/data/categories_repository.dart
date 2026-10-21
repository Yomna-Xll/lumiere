import 'package:lumiere/features/categories/data/category_model.dart';

abstract class CategoriesRepository {
  Future<List<CategoryModel>> getCategories();
}