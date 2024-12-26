import 'package:zibzo_app/core/typedef/typedef.dart';
import 'package:zibzo_app/core/usecase/usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/cart/cart_response_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/cart/cart_repository.dart';

class GetCartUseCase extends UseCaseNoParams<CartResponseEntity> {
  final CartRepository cartRepository;

  GetCartUseCase({required this.cartRepository});
  @override
  ResultFuture<CartResponseEntity> call() async {
    return await cartRepository.getCart();
  }
}
