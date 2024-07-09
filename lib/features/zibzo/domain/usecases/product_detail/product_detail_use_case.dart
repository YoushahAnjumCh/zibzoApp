import 'package:zibzo_app/core/typedef/typedef.dart';
import 'package:zibzo_app/core/usecase/usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/products/products.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/product/product_repository.dart';

class ProductDetailsUseCase extends UseCase<Products, int> {
  final ProductRepository productRepository;
  ProductDetailsUseCase(this.productRepository);
  @override
  ResultFuture<Products> call(int params) async {
    return await productRepository.getProductById(params);
  }
}
