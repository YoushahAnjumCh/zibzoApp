import 'package:zibzo_app/core/typedef/typedef.dart';
import 'package:zibzo_app/core/usecase/usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/category_products/category_products_repository.dart';

class CategoryProductsUseCase extends UseCase<List<ProductEntity>, String> {
  final CategoryProductsRepository repository;
  CategoryProductsUseCase(this.repository);

  @override
  ResultFuture<List<ProductEntity>> call(String params) async {
    return await repository.getCategoryProducts(params);
  }
}
