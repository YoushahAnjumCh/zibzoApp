part of 'add_cart_cubit.dart';

sealed class AddCartState extends Equatable {
  const AddCartState();

  @override
  List<Object> get props => [];
}

final class AddCartInitial extends AddCartState {}

final class AddCartLoading extends AddCartState {}

final class AddCartLoaded extends AddCartState {
  final CartCountEntity cart;

  const AddCartLoaded({required this.cart});

  @override
  List<Object> get props => [cart];
}

final class AddCartFailure extends AddCartState {
  final String errorMessage;

  const AddCartFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
