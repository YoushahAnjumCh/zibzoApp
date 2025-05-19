import 'package:zibzo/core/typedef/typedef.dart';
import 'package:zibzo/core/usecase/usecase.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_response_entity.dart';
import 'package:zibzo/features/zibzo/domain/repositories/home/home_repository.dart';

class ProductUseCase extends UseCaseNoParams<HomeResponseEntity> {
  final ProductRepository repository;
  ProductUseCase(this.repository);

  @override
  ResultFuture<HomeResponseEntity> call() async {
    return await repository.getProducts();
  }
}

class ProductsParams {
  final int limit;
  final int offset;
  const ProductsParams({this.limit = 10, this.offset = 0});
}
