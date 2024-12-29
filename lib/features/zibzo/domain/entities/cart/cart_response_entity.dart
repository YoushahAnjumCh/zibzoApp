import 'package:zibzo_app/features/zibzo/domain/entities/home/home_products_entity.dart';

class CartResponseEntity {
  final List<ProductEntity> products;
  final int cartProductCount;

  CartResponseEntity({
    required this.products,
    required this.cartProductCount,
  });
}
