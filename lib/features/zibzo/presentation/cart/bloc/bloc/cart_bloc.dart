import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/features/zibzo/domain/entities/cart/cart_response_entity.dart';
import 'package:zibzo/features/zibzo/domain/usecases/cart/delete_cart_usecase.dart';
import 'package:zibzo/features/zibzo/domain/usecases/cart/get_cart_usecase.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final DeleteCartUseCase deleteCartUseCase;
  CartBloc(this.deleteCartUseCase, this.getCartUseCase) : super(CartInitial()) {
    on<GetCartEvent>(_getCart);
    on<DeleteCartEvent>(_deleteCart);
  }

  Future<void> _getCart(GetCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      final cart = await getCartUseCase.call();
      cart.fold(
          (left) => emit(CartFailure(message: left.errorMessage.toString())),
          (cart) {
        cart.products.isEmpty
            ? emit(CartEmpty(
                message: 'Your cart is empty',
              ))
            : emit(CartSuccess(cartResponseEntity: cart));
        emit(CartSuccess(cartResponseEntity: cart));
      });
    } on ServerFailure catch (e) {
      emit(CartFailure(message: e.errorMessage.toString()));
    }
  }

  Future<void> _deleteCart(
      DeleteCartEvent event, Emitter<CartState> emit) async {
    try {
      final cart = await deleteCartUseCase.call(event.params);

      cart.fold(
          (left) => emit(CartFailure(
              message: left.errorMessage.toString(),
              errorCode: left.statusCode)), (cart) {
        emit(CartSuccess(cartResponseEntity: cart));
      });
    } on ServerFailure catch (e) {
      emit(CartFailure(
          message: e.errorMessage.toString(), errorCode: e.errorCode));
    }
  }
}
