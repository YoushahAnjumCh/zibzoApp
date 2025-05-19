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
import 'package:zibzo/features/zibzo/presentation/category_products/widgets/category_loading_widget.dart';
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

  late MockCategoryProductBloc mockCategoryProductBloc;
  late MockCartUseCase mockCartUseCase;
  late MockAppLocalStorage mockAppLocalStorage;

  Widget createTestWidget({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryProductBloc>(
          create: (_) => mockCategoryProductBloc,
        ),
        BlocProvider<AddCartCubit>(
          create: (_) => AddCartCubit(mockCartUseCase),
        ),
        ChangeNotifierProvider<CartCountProvider>(
          create: (_) => CartCountProvider(),
        ),
      ],
      child: MaterialApp(home: child),
    );
  }

  setUp(() {
    if (sl.isRegistered<AppLocalStorage>()) {
      sl.unregister<AppLocalStorage>();
    }

    mockCategoryProductBloc = MockCategoryProductBloc();
    mockCartUseCase = MockCartUseCase();
    mockAppLocalStorage = MockAppLocalStorage();

    sl.registerLazySingleton<AppLocalStorage>(() => mockAppLocalStorage);
  });

  group('CategoryProductsView Tests', () {
    testWidgets("displays loading state", (tester) async {
      when(() => mockCategoryProductBloc.state)
          .thenReturn(CategoryProductLoading());

      await tester.pumpWidget(
        createTestWidget(
          child: const CategoryProductsView(categoryName: "Men"),
        ),
      );

      expect(find.byType(CategoryLoadingWidget), findsOneWidget);
    });

    testWidgets("displays success state with products", (tester) async {
      when(() => mockCategoryProductBloc.state)
          .thenReturn(CategoryProductSuccess(tProducts));

      await tester.pumpWidget(
        createTestWidget(
          child: const CategoryProductsView(categoryName: "Men"),
        ),
      );

      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(ProductList), findsOneWidget);
    });

    testWidgets("displays failure state", (tester) async {
      when(() => mockCategoryProductBloc.state)
          .thenReturn(CategoryProductFailure("Failed to load products."));

      await tester.pumpWidget(
        createTestWidget(
          child: const CategoryProductsView(categoryName: "Men"),
        ),
      );

      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(ErrorMessage), findsOneWidget);
      expect(find.text("Failed to load products."), findsOneWidget);
    });
  });
}
