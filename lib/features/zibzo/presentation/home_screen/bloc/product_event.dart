part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class ProductFetchEvent extends ProductEvent {
  const ProductFetchEvent();
  @override
  List<Object> get props => [];
}

class ProductMoreEvent extends ProductEvent {
  final ProductsParams params;
  ProductMoreEvent(this.params);
  @override
  List<Object> get props => [params];
}
