import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/features/zibzo/domain/usecases/home_page/product_use_case.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/bloc/product_bloc.dart';

import '../../../../constants/product_params.dart';

class MockProductUseCase extends Mock implements ProductUseCase {}

void main() {
  late ProductBloc productBloc;
  late MockProductUseCase useCase;

  setUp(() {
    useCase = MockProductUseCase();
    productBloc = ProductBloc(useCase);
  });

  test("initial state should be ProductInitial", () {
    expect(productBloc.state, ProductInitial());
  });

  blocTest<ProductBloc, ProductState>(
    "emit[ProductLoading ,ProductLoaded] ",
    build: () {
      final productBloc = ProductBloc(useCase);
      when(() => useCase.call())
          .thenAnswer((_) async => Right(tHomeResponseEntity));
      return productBloc;
    },
    act: ((bloc) => bloc.add(ProductFetchEvent())),
    expect: () =>
        [ProductLoading(), ProductLoaded(product: tHomeResponseEntity)],
  );

  blocTest<ProductBloc, ProductState>(
    "emit[ProductLoading, ProductFail] when get home Products",
    build: () {
      final productBloc = ProductBloc(useCase);
      when(() => useCase.call()).thenAnswer(
          (_) async => const Left(ServerFailure("errorMessage", 401)));
      return productBloc;
    },
    act: ((bloc) => bloc.add(ProductFetchEvent())),
    expect: () => [ProductLoading(), ProductFail(errorMessage: "errorMessage")],
  );

  blocTest<ProductBloc, ProductState>(
    "emit[ServerFailure] when get home Products",
    build: () {
      final productBloc = ProductBloc(useCase);
      when(() => useCase.call())
          .thenThrow(const ServerFailure("Internal Server Error: ", 500));
      return productBloc;
    },
    act: ((bloc) => bloc.add(ProductFetchEvent())),
    expect: () => [
      ProductLoading(),
      ProductFail(errorMessage: "Internal Server Error: ")
    ],
  );
}
