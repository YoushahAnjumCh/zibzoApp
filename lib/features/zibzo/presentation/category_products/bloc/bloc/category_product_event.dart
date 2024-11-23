part of 'category_product_bloc.dart';

class CategoryProductEvent extends Equatable {
  final String categoryName;
  const CategoryProductEvent({required this.categoryName});

  @override
  List<Object> get props => [categoryName];
}
