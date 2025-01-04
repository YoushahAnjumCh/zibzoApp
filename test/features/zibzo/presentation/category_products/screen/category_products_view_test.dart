import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:zibzo/common/provider/cart_count_provider.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/domain/usecases/cart/add_cart_usecase.dart';
import 'package:zibzo/features/zibzo/domain/usecases/category_products/category_products_use_case.dart';
import 'package:zibzo/features/zibzo/presentation/category_products/bloc/bloc/category_product_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/category_products/screen/category_products_view.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/cubit/add_cart/add_cart_cubit.dart';

import '../../../../constants/product_params.dart';

class MockCategoryProductsUseCase extends Mock
    implements CategoryProductsUseCase {}

class MockCartUseCase extends Mock implements AddCartUseCase {}

class MockAppLocalStorage extends Mock implements AppLocalStorage {}

class MockCategoryProductBloc
    extends MockBloc<CategoryProductEvent, CategoryProductState>
    implements CategoryProductBloc {}

class MockCartCountProvider extends Mock implements CartCountProvider {}

class FakeCategoryProductState extends Fake implements CategoryProductState {}

class FakeCategoryProductEvent extends Fake implements CategoryProductEvent {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
    registerFallbackValue(FakeCategoryProductState());
    registerFallbackValue(FakeCategoryProductEvent());
  });

  testWidgets("success", (tester) async {
    // Initialize Widgets
    WidgetsFlutterBinding.ensureInitialized();

    // Mock Bloc
    final mockCategoryProductBloc = MockCategoryProductBloc();

    late MockCartUseCase mockCartUseCase;
    late MockAppLocalStorage mockAppLocalStorage;
    mockCartUseCase = MockCartUseCase();
    mockAppLocalStorage = MockAppLocalStorage();
    sl.registerLazySingleton<AppLocalStorage>(() => mockAppLocalStorage);
    when(() => mockCategoryProductBloc.state).thenReturn(
      CategoryProductSuccess(tProducts), // Mocked list of products
    );

    // Build Widget
    final widget = MultiBlocProvider(
      providers: [
        BlocProvider<CategoryProductBloc>(
          create: (context) => mockCategoryProductBloc,
        ),
        ChangeNotifierProvider<CartCountProvider>(
          create: (context) => CartCountProvider(),
        ),
        BlocProvider<AddCartCubit>(
          create: (context) => AddCartCubit(mockCartUseCase),
        ),
      ],
      child: MaterialApp(
        title: 'Widget Test',
        home: CategoryProductsView(categoryName: "Men"),
      ),
    );

    // Pump the widget
    await tester.pumpWidget(widget);

    // Simulate some delay to allow the widget to build
    await tester.pump(const Duration(seconds: 4));

    // Expect `ProductList` widget is present
    expect(find.byType(ProductList), findsOneWidget);
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
      MultiBlocProvider(
        providers: [
          BlocProvider<CategoryProductBloc>(
            create: (context) => mockAuthenticationBloc,
          ),
          ChangeNotifierProvider<CartCountProvider>(
            create: (context) => CartCountProvider(),
          ),
        ],
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
