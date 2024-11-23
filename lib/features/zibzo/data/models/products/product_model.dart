import 'package:zibzo_app/features/zibzo/domain/entities/home/home_products_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required String id,
    required String title,
    required double offerPrice,
    required String subtitle,
    required double offerPercentage,
    required double actualPrice,
    required List<String> image,
  }) : super(
          id: id,
          title: title,
          subtitle: subtitle,
          image: image,
          offerPercentage: offerPercentage,
          actualPrice: actualPrice,
          offerPrice: offerPrice,
        );

  // Factory constructor to create a ProductEntity from a JSON map
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      title: json['title'],
      offerPrice: (json['offerPrice'] as num).toDouble(),
      actualPrice: (json['actualPrice'] as num).toDouble(),
      subtitle: json['subtitle'],
      offerPercentage: (json['offerPercentage'] as num).toDouble(),
      image: List<String>.from(json['image'] as List),
    );
  }

  // Method to convert a ProductEntity instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'offerPrice': offerPrice,
      'actualPrice': actualPrice,
      'subtitle': subtitle,
      'offerPercentage': offerPercentage,
      'image': image,
    };
  }
}
