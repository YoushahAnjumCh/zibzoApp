import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/category_products/category_products_use_case.dart';
import 'package:zibzo_app/features/zibzo/presentation/category_products/bloc/bloc/category_product_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/category_products/screen/category_products_view.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/widgets/product_card_widget.dart';

import '../../../../constants/product_params.dart';

class MockCategoryProductsUseCase extends Mock
    implements CategoryProductsUseCase {}

class MockCategoryProductBloc
    extends MockBloc<CategoryProductEvent, CategoryProductState>
    implements CategoryProductBloc {}

class FakeCategoryProductState extends Fake implements CategoryProductState {}

class FakeCategoryProductEvent extends Fake implements CategoryProductEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCategoryProductState());
    registerFallbackValue(FakeCategoryProductEvent());
  });

  testWidgets("success", (tester) async {
    WidgetsFlutterBinding.ensureInitialized();

    final mockAuthenticationBloc = MockCategoryProductBloc();
    when(() => mockAuthenticationBloc.state).thenReturn(
      CategoryProductSuccess(tProducts), // the desired state
    );
    final widget = CategoryProductsView(
      categoryName: "Men",
    );
    await tester.pumpWidget(
      BlocProvider<CategoryProductBloc>(
        create: (context) => mockAuthenticationBloc,
        child: MaterialApp(
          title: 'Widget Test',
          home: Scaffold(body: widget),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 4)); // Simulates some delay
    expect(find.byType(ProductCard), findsOneWidget);
  });

  testWidgets("failure", (tester) async {
    WidgetsFlutterBinding.ensureInitialized();

    final mockAuthenticationBloc = MockCategoryProductBloc();
    when(() => mockAuthenticationBloc.state).thenReturn(
      CategoryProductFailure("ailure"), // the desired state
    );
    final widget = CategoryProductsView(
      categoryName: "Men",
    );
    await tester.pumpWidget(
      BlocProvider<CategoryProductBloc>(
        create: (context) => mockAuthenticationBloc,
        child: MaterialApp(
          title: 'Widget Test',
          home: Scaffold(body: widget),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 4)); // Simulates some delay
    expect(find.byType(ErrorMessage), findsOneWidget);
  });
}
