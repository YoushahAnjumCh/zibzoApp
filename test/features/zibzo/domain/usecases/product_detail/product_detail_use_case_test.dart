import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/product/product_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/product_detail/product_detail_use_case.dart';

import '../../../../constants/product_params.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository repository;
  late ProductDetailsUseCase useCase;

  setUp(() {
    repository = MockProductRepository();
    useCase = ProductDetailsUseCase(repository);
  });
  test('should return product details', () async {
    //Arange
    when(() => repository.getProductById(1))
        .thenAnswer((_) async => Right(tProduct));

//Act
    final result = await useCase.call(1);
//Assert
    expect(result, equals(Right(tProduct)));
  });
  verify(() => repository.getProductById(1));
  verifyNoMoreInteractions(repository);
}
