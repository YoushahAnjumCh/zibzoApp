import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/cart/cart_count_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/cart/cart_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/cart/add_cart_usecase.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late MockCartRepository repository;
  late AddCartUseCase useCase;

  setUp(() {
    repository = MockCartRepository();
    useCase = AddCartUseCase(cartRepository: repository);
  });

  test('should return CartCountEntity from repository when call is successful',
      () async {
    // Arrange
    final params = AddCartParams(productId: '123');
    final cartCountEntity = CartCountEntity(cartCount: 1);
    when(() => repository.addCart(params))
        .thenAnswer((_) async => Right(cartCountEntity));

    // Act
    final result = await useCase(params);

    // Assert
    expect(result, Right(cartCountEntity));
  });
}
