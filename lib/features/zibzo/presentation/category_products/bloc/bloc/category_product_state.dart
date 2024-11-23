part of 'category_product_bloc.dart';

class CategoryProductState extends Equatable {
  const CategoryProductState();

  @override
  List<Object> get props => [];
}

final class CategoryProductInitial extends CategoryProductState {}

final class CategoryProductLoading extends CategoryProductState {}

final class CategoryProductFailure extends CategoryProductState {
  final String message;

  const CategoryProductFailure(this.message);
}

final class CategoryProductSuccess extends CategoryProductState {
  final List<ProductEntity> product;

  const CategoryProductSuccess(this.product);
}
