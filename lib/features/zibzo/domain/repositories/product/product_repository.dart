import 'package:zibzo_app/core/typedef/typedef.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/products/products.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/home_page/product_use_case.dart';

abstract class ProductRepository {
  ResultFuture<List<Products>> getProducts(ProductsParams params);
  ResultFuture<Products> getProductById(int id);
}
