import 'package:zibzo_app/features/zibzo/domain/entities/cart/product_id_entity.dart';

class CartEntity {
  final String id;
  final String userID;
  final List<ProductIDEntity> products;
  final int version;

  CartEntity({
    required this.id,
    required this.userID,
    required this.products,
    required this.version,
  });
}
