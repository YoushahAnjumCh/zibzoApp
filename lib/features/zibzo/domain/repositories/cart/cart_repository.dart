import 'package:zibzo/core/typedef/typedef.dart';
import 'package:zibzo/features/zibzo/domain/entities/cart/cart_count_entity.dart';
import 'package:zibzo/features/zibzo/domain/entities/cart/cart_response_entity.dart';
import 'package:zibzo/features/zibzo/domain/usecases/cart/add_cart_usecase.dart';
import 'package:zibzo/features/zibzo/domain/usecases/cart/delete_cart_usecase.dart';

abstract class CartRepository {
  ResultFuture<CartCountEntity> addCart(AddCartParams params);
  ResultFuture<CartResponseEntity> getCart();
  ResultFuture<CartResponseEntity> removeCart(DeleteCartParams params);
}
