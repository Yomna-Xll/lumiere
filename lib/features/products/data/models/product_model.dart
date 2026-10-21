class ProductModel {
  final String id;
  final String name;
  final String description;
  final String coverPictureUrl;
  final List<String> productPictures;
  final double price;
  final int stock;
  final double weight;
  final String color;
  final double rating;
  final int reviewsCount;
  final double discountPercentage;
  final List<String> categories;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.coverPictureUrl,
    required this.productPictures,
    required this.price,
    required this.stock,
    required this.weight,
    required this.color,
    required this.rating,
    required this.reviewsCount,
    required this.discountPercentage,
    required this.categories,
  });

  bool get hasDiscount => discountPercentage > 0;
  bool get isSoldOut => stock <= 0;
  bool get isLowStock => stock > 0 && stock <= 10;
  double get finalPrice => price * (1 - discountPercentage / 100);

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    coverPictureUrl: json['coverPictureUrl'] as String? ?? '',
    productPictures: (json['productPictures'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList(),
    price: (json['price'] as num?)?.toDouble() ?? 0,
    stock: (json['stock'] as num?)?.toInt() ?? 0,
    weight: (json['weight'] as num?)?.toDouble() ?? 0,
    color: json['color'] as String? ?? '',
    rating: (json['rating'] as num?)?.toDouble() ?? 0,
    reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
    discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
    categories: (json['categories'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList(),
  );
}
