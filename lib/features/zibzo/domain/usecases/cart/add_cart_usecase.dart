import 'package:zibzo_app/core/typedef/typedef.dart';
import 'package:zibzo_app/core/usecase/usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/cart/cart_count_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/cart/cart_repository.dart';

class AddCartUseCase extends UseCase<CartCountEntity, AddCartParams> {
  final CartRepository cartRepository;

  AddCartUseCase({required this.cartRepository});
  @override
  ResultFuture<CartCountEntity> call(AddCartParams params) async {
    return await cartRepository.addCart(params);
  }
}

class AddCartParams {
  final String productId;

  AddCartParams({required this.productId});
}
