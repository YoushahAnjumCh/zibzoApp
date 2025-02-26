import 'package:zibzo/core/typedef/typedef.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo/features/zibzo/domain/usecases/search/search_usecase.dart';

abstract class SearchRepository {
  ResultFuture<List<ProductEntity>> searchProduct(SearchUseCaseParams query);
}
