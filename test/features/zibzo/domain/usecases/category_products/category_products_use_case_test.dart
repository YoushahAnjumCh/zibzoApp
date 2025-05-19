import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo/features/zibzo/domain/repositories/category_products/category_products_repository.dart';
import 'package:zibzo/features/zibzo/domain/usecases/category_products/category_products_use_case.dart';

import '../../../../constants/product_params.dart';

class MockCategoryProductsRepository extends Mock
    implements CategoryProductsRepository {}

void main() {
  late MockCategoryProductsRepository repository;
  late CategoryProductsUseCase useCase;

  setUp(() {
    repository = MockCategoryProductsRepository();
    useCase = CategoryProductsUseCase(repository);
  });

  test("Should return List pf Product Entity from repository called", () async {
    const tParams = "Men";
    //Arrange
    when(() => repository.getCategoryProducts(tParams))
        .thenAnswer((_) async => const Right(tProducts));
    //Act
    final result = await useCase(tParams);
    //Assert
    expect(result, const Right(tProducts));
  });
}
