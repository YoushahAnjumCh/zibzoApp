import 'package:zibzo/core/typedef/typedef.dart';
import 'package:zibzo/core/usecase/usecase.dart';
import 'package:zibzo/features/zibzo/domain/entities/cart/cart_response_entity.dart';
import 'package:zibzo/features/zibzo/domain/repositories/cart/cart_repository.dart';

class GetCartUseCase extends UseCaseNoParams<CartResponseEntity> {
  final CartRepository cartRepository;

  GetCartUseCase({required this.cartRepository});
  @override
  ResultFuture<CartResponseEntity> call() async {
    return await cartRepository.getCart();
  }
}
