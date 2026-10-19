import 'package:lumiere/features/products/data/models/product_model.dart';

const List<ProductModel> sampleProducts = [
  ProductModel(
    id: '1',
    name: 'Ruby Red Heart Solitaire Charm',
    description:
        'Vivid crimson heart-cut gemstone mounted in a three-prong golden basket.',
    coverPictureUrl:
        'https://images.metmuseum.org/CRDImages/ad/web-large/DP-15303-006.jpg',
    price: 2100,
    stock: 18,
    weight: 2.7,
    color: 'Ruby Red',
    rating: 5,
    reviewsCount: 2,
    discountPercentage: 0,
    categories: ['charms', 'jewelry'],
  ),
  ProductModel(
    id: '2',
    name: 'Lucky Four Leaf Clover Charm',
    description:
        'Traditional clover symbol featuring heart-shaped emerald green petals.',
    coverPictureUrl:
        'https://images.metmuseum.org/CRDImages/eg/web-large/22.1.58_EGDP015403.jpg',
    price: 1600,
    stock: 30,
    weight: 3,
    color: 'Emerald Green',
    rating: 2,
    reviewsCount: 1,
    discountPercentage: 5,
    categories: ['charms', 'jewelry'],
  ),
  ProductModel(
    id: '3',
    name: 'Emerald Crown Medallion Pendant',
    description:
        'Regal round disc with a raised golden crown centered over a vivid green emerald.',
    coverPictureUrl:
        'https://images.metmuseum.org/CRDImages/es/web-large/DP-35998-001.jpg',
    price: 11500,
    stock: 8,
    weight: 8,
    color: 'Emerald Green',
    rating: 5,
    reviewsCount: 1,
    discountPercentage: 12,
    categories: ['pendants', 'jewelry'],
  ),
  ProductModel(
    id: '4',
    name: 'Turquoise Inlay Cuff Bracelet',
    description:
        'Artisanal silver cuff inlaid with genuine natural turquoise mosaic stones.',
    coverPictureUrl:
        'https://images.metmuseum.org/CRDImages/ao/web-large/DP-26558-002.jpg',
    price: 3800,
    stock: 0,
    weight: 15,
    color: 'Mixed',
    rating: 0,
    reviewsCount: 0,
    discountPercentage: 15,
    categories: ['jewelry', 'bracelets'],
  ),
];
