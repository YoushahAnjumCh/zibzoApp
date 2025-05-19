import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo/features/zibzo/domain/entities/cart/cart_response_entity.dart';
import 'package:zibzo/features/zibzo/domain/repositories/cart/cart_repository.dart';
import 'package:zibzo/features/zibzo/domain/usecases/cart/get_cart_usecase.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late MockCartRepository repository;
  late GetCartUseCase useCase;

  setUp(() {
    repository = MockCartRepository();
    useCase = GetCartUseCase(cartRepository: repository);
  });

  test(
      'should return CartResponseEntity from repository when call is successful',
      () async {
    // Arrange
    final cartResponseEntity = CartResponseEntity(
      products: [],
      cartProductCount: 2,
    );

    when(() => repository.getCart())
        .thenAnswer((_) async => Right(cartResponseEntity));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Right(cartResponseEntity));
  });
}
