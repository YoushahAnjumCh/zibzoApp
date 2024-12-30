import 'package:zibzo/features/zibzo/domain/entities/cart/cart_count_entity.dart';

class CartCountModel extends CartCountEntity {
  CartCountModel({
    required int cartCount,
  }) : super(cartCount: cartCount);

  factory CartCountModel.fromJson(Map<String, dynamic> json) {
    return CartCountModel(
      cartCount: json['cartProductCount'],
    );
  }
}
