import 'package:zibzo_app/core/typedef/typedef.dart';
import 'package:zibzo_app/core/usecase/usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/products/products.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/product/product_repository.dart';

class ProductUseCase extends UseCase<List<Products>, ProductsParams> {
  final ProductRepository repository;
  ProductUseCase(this.repository);

  @override
  ResultFuture<List<Products>> call(ProductsParams params) async {
    return await repository.getProducts(params);
  }
}

class ProductsParams {
  final int limit;
  final int offset;
  const ProductsParams({this.limit = 10, this.offset = 0});
}
