part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartDeleteLoading extends CartState {}

class CartSuccess extends CartState {
  final CartResponseEntity cartResponseEntity;

  const CartSuccess({required this.cartResponseEntity});

  @override
  List<Object> get props => [cartResponseEntity];
}

class CartFailure extends CartState {
  final String message;
  final int? errorCode;
  const CartFailure({required this.message, this.errorCode});

  @override
  List<Object> get props => [message];
}
