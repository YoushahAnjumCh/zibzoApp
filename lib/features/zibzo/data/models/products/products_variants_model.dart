import 'package:zibzo/features/zibzo/domain/entities/home/products_variants.dart';

class ProductVariantModel extends ProductVariant {
  ProductVariantModel({
    int? price,
    int? stock,
    String? id,
  }) : super(
          price: price,
          stock: stock,
          id: id,
        );

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      price: json['price'] as int,
      stock: json['stock'] as int,
      id: json['_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'stock': stock,
      'id': id,
    };
  }
}
  
  // final double price;
  // final int stock;
  // final String id;

  // ProductVariantModel({
  //   required this.price,
  //   required this.stock,
  //   required this.id,
  // });