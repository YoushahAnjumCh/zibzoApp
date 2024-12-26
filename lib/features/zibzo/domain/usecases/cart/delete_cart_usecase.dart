import 'package:zibzo_app/core/typedef/typedef.dart';
import 'package:zibzo_app/core/usecase/usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/cart/cart_response_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/cart/cart_repository.dart';

class DeleteCartUseCase extends UseCase<CartResponseEntity, DeleteCartParams> {
  final CartRepository cartRepository;

  DeleteCartUseCase({required this.cartRepository});
  @override
  ResultFuture<CartResponseEntity> call(DeleteCartParams params) async {
    return await cartRepository.removeCart(params);
  }
}

class DeleteCartParams {
  final String productID;

  DeleteCartParams({required this.productID});
}
