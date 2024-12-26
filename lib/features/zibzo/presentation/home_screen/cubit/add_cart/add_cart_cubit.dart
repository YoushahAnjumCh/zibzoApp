import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/cart/cart_count_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/cart/add_cart_usecase.dart';

part 'add_cart_state.dart';

class AddCartCubit extends Cubit<AddCartState> {
  final AddCartUseCase addCartUseCase;
  final Map<String, bool> _loadingState = {};

  AddCartCubit(this.addCartUseCase) : super(AddCartInitial());

  Future<int?> addCart(AddCartParams params) async {
    try {
      _setLoading(params.productId, true);
      emit(AddCartLoading());

      final cartResult = await addCartUseCase.call(params);

      return cartResult.fold(
        (failure) {
          _setLoading(params.productId, false);
          emit(AddCartFailure(errorMessage: failure.errorMessage.toString()));
          return null;
        },
        (cart) {
          _setLoading(params.productId, false);
          emit(AddCartLoaded(cart: cart));
          return cart.cartCount;
        },
      );
    } on ServerFailure catch (e) {
      _setLoading(params.productId, false);
      emit(AddCartFailure(errorMessage: e.errorMessage.toString()));
      return null;
    }
  }

  void _setLoading(String productId, bool isLoading) {
    _loadingState[productId] = isLoading;
  }

  bool isLoading(String productId) {
    return _loadingState[productId] ?? false;
  }
}
