import 'package:zibzo_app/core/typedef/typedef.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_products_entity.dart';

abstract class CategoryProductsRepository {
  ResultFuture<List<ProductEntity>> getCategoryProducts(String categoryName);
}
