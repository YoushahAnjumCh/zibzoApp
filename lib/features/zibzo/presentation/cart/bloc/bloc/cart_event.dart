part of 'cart_bloc.dart';

abstract class CartEvent {
  CartEvent();
}

class GetCartEvent extends CartEvent {
  GetCartEvent();
}

class DeleteCartEvent extends CartEvent {
  final DeleteCartParams params;
  DeleteCartEvent({required this.params});
}
