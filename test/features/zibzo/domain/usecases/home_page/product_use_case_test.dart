import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_response_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/home/home_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/home_page/product_use_case.dart';

import '../../../../constants/product_params.dart';

class MockSignRepository extends Mock implements ProductRepository {}

void main() {
  late MockSignRepository repository;
  late ProductUseCase useCase;

  setUp(() {
    repository = MockSignRepository();
    useCase = ProductUseCase(repository);
  });

  test("Should return ProductResponse from repository called", () async {
    //Arrange
    when(() => repository.getProducts()).thenAnswer((_) async =>
        const Right<Failure, HomeResponseEntity>(tHomeResponseEntity));
    //Act
    final result = await useCase();
    //Assert
    expect(
        result, const Right<Failure, HomeResponseEntity>(tHomeResponseEntity));
  });
}
