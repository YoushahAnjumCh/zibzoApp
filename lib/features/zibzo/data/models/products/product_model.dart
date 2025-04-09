import 'package:zibzo/features/zibzo/data/models/products/products_variants_model.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_products_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required String id,
    required String productName,
    required double offerPrice,
    required String brand,
    required String category,
    Map<String, ProductVariantModel> variants = const {},
    required String description,
    required double offerPercentage,
    required double actualPrice,
    required List<String> image,
  }) : super(
          id: id,
          productName: productName,
          brand: brand,
          category: category,
          description: description,
          variants: variants,
          image: image,
          offerPercentage: offerPercentage,
          actualPrice: actualPrice,
          offerPrice: offerPrice,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    var variantsJson = json['variants'] as Map<String, dynamic>;
    var variantsMap = <String, ProductVariantModel>{};
    variantsJson.forEach((key, value) {
      variantsMap[key] =
          ProductVariantModel.fromJson(value as Map<String, dynamic>);
    });
    return ProductModel(
      id: json['_id'],
      productName: json['productName'],
      brand: json['brand'],
      category: json['category'],
      description: json['description'],
      variants: variantsMap,
      offerPrice: (json['offerPrice'] as num?)?.toDouble() ?? 0.0,
      actualPrice: (json['actualPrice'] as num?)?.toDouble() ?? 0.0,
      offerPercentage: (json['discount'] as num?)?.toDouble() ?? 0.0,
      image: List<String>.from(json['image'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productName': productName,
      'brand': brand,
      'category': category,
      'description': description,
      'offerPrice': offerPrice,
      'actualPrice': actualPrice,
      'offerPercentage': offerPercentage,
      'image': image,
    };
  }
}
