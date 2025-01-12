import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/features/zibzo/domain/usecases/category_products/category_products_use_case.dart';
import 'package:zibzo/features/zibzo/presentation/category_products/bloc/bloc/category_product_bloc.dart';

import '../../../../../constants/product_params.dart';

class MockCategoryProductsUseCase extends Mock
    implements CategoryProductsUseCase {}

void main() {
  late CategoryProductBloc categoryProductBloc;
  late MockCategoryProductsUseCase useCase;

  setUp(() {
    useCase = MockCategoryProductsUseCase();
    categoryProductBloc = CategoryProductBloc(useCase);
  });
  test("initial state should be CategoryProductInitial", () {
    expect(categoryProductBloc.state, CategoryProductInitial());
  });

  blocTest<CategoryProductBloc, CategoryProductState>(
    "emit[CategoryProductLoading ,CategoryProductSuccess] ",
    build: () {
      final categoryBloc = CategoryProductBloc(useCase);
      when(() => useCase.call("Men")).thenAnswer((_) async => Right(tProducts));
      return categoryBloc;
    },
    act: ((bloc) => bloc.add(CategoryProductEvent(categoryName: "Men"))),
    expect: () => [CategoryProductLoading(), CategoryProductSuccess(tProducts)],
  );

  blocTest<CategoryProductBloc, CategoryProductState>(
      "emit[CategoryProductLoading ,CategoryProductFailure] ",
      build: () {
        final categoryBloc = CategoryProductBloc(useCase);
        when(() => useCase.call("Men"))
            .thenAnswer((_) async => Left(ServerFailure("errorMessage", 401)));
        return categoryBloc;
      },
      act: ((bloc) => bloc.add(CategoryProductEvent(categoryName: "Men"))),
      expect: () =>
          [CategoryProductLoading(), CategoryProductFailure("errorMessage")]);

  blocTest<CategoryProductBloc, CategoryProductState>(
      "emit[Serverailure] when get category Products",
      build: () {
        final categoryBloc = CategoryProductBloc(useCase);
        when(() => useCase.call("Men"))
            .thenThrow(ServerFailure("Internal Server Error: ", 500));
        return categoryBloc;
      },
      act: ((bloc) => bloc.add(CategoryProductEvent(categoryName: "Men"))),
      expect: () => [
            CategoryProductLoading(),
            CategoryProductFailure("Internal Server Error: ")
          ]);
}
