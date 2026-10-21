class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String coverPictureUrl;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.coverPictureUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        coverPictureUrl: json['coverPictureUrl'] as String? ?? '',
      );
}