import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/product/product_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/home_page/product_use_case.dart';

import '../../../../constants/product_params.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository repository;
  late ProductUseCase useCase;

  setUp(() {
    repository = MockProductRepository();
    useCase = ProductUseCase(repository);
  });
  test("should return Products when call getProducts", () async {
    //Arrange
    when(() => repository.getProducts(tProductParams))
        .thenAnswer((_) async => const Right(tProducts));

    //Act
    final result = await useCase(tProductParams);

    //Assert

    expect(result, equals(Right(tProducts)));
  });
}
