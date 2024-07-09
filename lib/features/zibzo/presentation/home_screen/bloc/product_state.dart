part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {
  final ProductsParams params;
  const ProductInitial({required this.params});
  @override
  List<Object> get props => [params];
}

final class ProductLoading extends ProductState {}

final class ProductFail extends ProductState {
  final String errorMessage;
  const ProductFail({required this.errorMessage});
}

final class ProductLoaded extends ProductState {
  final List<Products> product;

  const ProductLoaded({required this.product});
  @override
  List<Object> get props => [product];
}
