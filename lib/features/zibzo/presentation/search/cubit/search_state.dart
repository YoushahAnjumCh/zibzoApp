import 'package:zibzo/features/zibzo/domain/entities/home/home_products_entity.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<ProductEntity> products;

  SearchLoaded(this.products);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
