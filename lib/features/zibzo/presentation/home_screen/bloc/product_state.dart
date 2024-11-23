part of 'product_bloc.dart';

class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {
  const ProductInitial();
  @override
  List<Object> get props => [];
}

final class ProductLoading extends ProductState {}

final class ProductFail extends ProductState {
  final String errorMessage;
  const ProductFail({required this.errorMessage});
}

final class ProductLoaded extends ProductState {
  final HomeResponseEntity product;

  const ProductLoaded({required this.product});
  @override
  List<Object> get props => [product];
}
