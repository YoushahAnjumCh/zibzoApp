part of 'product_bloc.dart';

abstract class ProductEvent {
  const ProductEvent();
}

class ProductFetchEvent extends ProductEvent {
  const ProductFetchEvent();
}
