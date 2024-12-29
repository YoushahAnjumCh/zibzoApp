import 'package:zibzo_app/features/zibzo/data/models/products/product_model.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/cart/cart_response_entity.dart';

class CartResponseModel extends CartResponseEntity {
  CartResponseModel({
    required List<ProductModel> products,
    required int cartProductCount,
  }) : super(
          products: products,
          cartProductCount: cartProductCount,
        );

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      products: (json['products'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList(),
      cartProductCount: json['cartProductCount'],
    );
  }
}
