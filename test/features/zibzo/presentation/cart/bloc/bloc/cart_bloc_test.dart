import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/cart/cart_response_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/cart/delete_cart_usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/cart/get_cart_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/cart/bloc/bloc/cart_bloc.dart';

import '../../../../../constants/product_params.dart';

class MockGetCartUseCase extends Mock implements GetCartUseCase {}

class MockDeleteCartUseCase extends Mock implements DeleteCartUseCase {}

void main() {
  late CartBloc cartBloc;
  late MockDeleteCartUseCase mockDeleteCartUseCase;
  late MockGetCartUseCase mockGetCartUseCase;

  final cartResponse =
      CartResponseEntity(products: [tProduct], cartProductCount: 1);
  final deleteParams = DeleteCartParams(productID: "productID");
  setUp(() {
    mockGetCartUseCase = MockGetCartUseCase();
    mockDeleteCartUseCase = MockDeleteCartUseCase();
    cartBloc = CartBloc(mockDeleteCartUseCase, mockGetCartUseCase);
  });

  test("initial state should be CartInitial", () {
    expect(cartBloc.state, CartInitial());
  });

  group("get Cart Bloc Test", () {
    blocTest<CartBloc, CartState>(
      "emit[CartInitial, CartSuccess]",
      build: () {
        final cartBloc = CartBloc(mockDeleteCartUseCase, mockGetCartUseCase);
        when(() => mockGetCartUseCase.call())
            .thenAnswer((_) async => Right(cartResponse));
        return cartBloc;
      },
      act: (bloc) => bloc.add(GetCartEvent()),
      expect: () =>
          [CartLoading(), CartSuccess(cartResponseEntity: cartResponse)],
    );

    blocTest<CartBloc, CartState>(
      "emit[CartInitial, CartFailure]",
      build: () {
        final cartBloc = CartBloc(mockDeleteCartUseCase, mockGetCartUseCase);
        when(() => mockGetCartUseCase.call()).thenAnswer(
            (_) async => const Left(ServerFailure("errorMessage", 404)));
        return cartBloc;
      },
      act: (bloc) => bloc.add(GetCartEvent()),
      expect: () =>
          [CartLoading(), CartFailure(message: "errorMessage", errorCode: 404)],
    );

    blocTest<CartBloc, CartState>(
      "emit[CartInitial, ServerFailure]",
      build: () {
        final cartBloc = CartBloc(mockDeleteCartUseCase, mockGetCartUseCase);
        when(() => mockGetCartUseCase.call())
            .thenThrow(const ServerFailure("Internal Server Error", 500));
        return cartBloc;
      },
      act: (bloc) => bloc.add(GetCartEvent()),
      expect: () => [
        CartLoading(),
        CartFailure(message: "Internal Server Error", errorCode: 404)
      ],
    );
  });

  group("Delete Cart Bloc Test", () {
    blocTest<CartBloc, CartState>(
      "emit[CartInitial, CartSuccess]",
      build: () {
        final cartBloc = CartBloc(mockDeleteCartUseCase, mockGetCartUseCase);
        when(() => mockDeleteCartUseCase.call(deleteParams))
            .thenAnswer((_) async => Right(cartResponse));
        return cartBloc;
      },
      act: (bloc) => bloc.add(DeleteCartEvent(params: deleteParams)),
      expect: () => [CartSuccess(cartResponseEntity: cartResponse)],
    );

    blocTest<CartBloc, CartState>(
      "emit[CartInitial, CartFailure]",
      build: () {
        final cartBloc = CartBloc(mockDeleteCartUseCase, mockGetCartUseCase);
        when(() => mockDeleteCartUseCase.call(deleteParams)).thenAnswer(
            (_) async => const Left(ServerFailure("errorMessage", 404)));
        return cartBloc;
      },
      act: (bloc) => bloc.add(DeleteCartEvent(params: deleteParams)),
      expect: () => [CartFailure(message: "errorMessage", errorCode: 404)],
    );

    blocTest<CartBloc, CartState>(
      "emit[CartInitial, ServerFailure]",
      build: () {
        final cartBloc = CartBloc(mockDeleteCartUseCase, mockGetCartUseCase);
        when(() => mockDeleteCartUseCase.call(deleteParams))
            .thenThrow(const ServerFailure("Internal Server Error", 500));
        return cartBloc;
      },
      act: (bloc) => bloc.add(DeleteCartEvent(params: deleteParams)),
      expect: () =>
          [CartFailure(message: "Internal Server Error", errorCode: 404)],
    );
  });
}
