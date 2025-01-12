import 'package:zibzo/features/zibzo/domain/entities/cart/product_id_entity.dart';

class ProductIDModel extends ProductIDEntity {
  ProductIDModel({
    required String id,
    required int count,
  }) : super(
          id: id,
          count: count,
        );

  factory ProductIDModel.fromJson(Map<String, dynamic> json) {
    return ProductIDModel(
      id: json['id'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'count': count,
    };
  }
}
