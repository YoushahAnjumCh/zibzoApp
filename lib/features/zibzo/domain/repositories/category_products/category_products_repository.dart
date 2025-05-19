import 'package:zibzo/core/typedef/typedef.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_products_entity.dart';

abstract class CategoryProductsRepository {
  ResultFuture<List<ProductEntity>> getCategoryProducts(String categoryName);
}
