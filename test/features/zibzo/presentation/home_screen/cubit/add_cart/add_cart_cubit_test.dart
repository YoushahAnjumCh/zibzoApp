import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/cart/cart_count_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/cart/add_cart_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/cubit/add_cart/add_cart_cubit.dart';

class MockAddCartUseCase extends Mock implements AddCartUseCase {}

void main() {
  late MockAddCartUseCase mockAddCartUseCase;
  late AddCartCubit cubit;

  setUp(() {
    mockAddCartUseCase = MockAddCartUseCase();
    cubit = AddCartCubit(mockAddCartUseCase);
  });

  const productId = "productId";
  final params = AddCartParams(productId: productId);
  final response = CartCountEntity(cartCount: 1);

  group('AddCartCubit', () {
    blocTest<AddCartCubit, AddCartState>(
      'emits [AddCartLoading, AddCartLoaded] when addCart is successful',
      setUp: () {
        when(() => mockAddCartUseCase.call(params))
            .thenAnswer((_) async => Right(response));
      },
      build: () => cubit,
      act: (cubit) => cubit.addCart(params),
      expect: () => [
        AddCartLoading(),
        AddCartLoaded(cart: response),
      ],
      verify: (_) {
        verify(() => mockAddCartUseCase.call(params)).called(1);
      },
    );

    blocTest<AddCartCubit, AddCartState>(
      'emits [AddCartLoading, AddCartFailure] when addCart fails',
      setUp: () {
        when(() => mockAddCartUseCase.call(params)).thenAnswer(
          (_) async => Left(ServerFailure("Server error", 404)),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.addCart(params),
      expect: () => [
        AddCartLoading(),
        AddCartFailure(errorMessage: "Server error"),
      ],
      verify: (_) {
        verify(() => mockAddCartUseCase.call(params)).called(1);
      },
    );

    blocTest<AddCartCubit, AddCartState>(
      'tracks loading state correctly during addCart operation',
      setUp: () {
        when(() => mockAddCartUseCase.call(params))
            .thenAnswer((_) async => Right(response));
      },
      build: () => cubit,
      act: (cubit) async {
        cubit.addCart(params);
        expect(cubit.isLoading(productId), true);
        await Future.delayed(
            Duration(milliseconds: 500)); // Simulate async behavior
      },
      verify: (_) {
        expect(cubit.isLoading(productId), false);
      },
    );
  });
}
