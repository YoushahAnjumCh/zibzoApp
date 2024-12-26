import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/cart/cart_response_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/cart/cart_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/cart/delete_cart_usecase.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late MockCartRepository repository;
  late DeleteCartUseCase useCase;

  setUp(() {
    repository = MockCartRepository();
    useCase = DeleteCartUseCase(cartRepository: repository);
  });

  test(
      'should return CartResponseEntity from repository when call is successful',
      () async {
    // Arrange
    final params = DeleteCartParams(productID: '123');
    final cartResponseEntity = CartResponseEntity(
      products: [],
      cartProductCount: 0,
    );

    when(() => repository.removeCart(params))
        .thenAnswer((_) async => Right(cartResponseEntity));

    // Act
    final result = await useCase(params);

    // Assert
    expect(result, Right(cartResponseEntity));
  });
}
