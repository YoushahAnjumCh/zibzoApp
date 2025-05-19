import 'dart:io';

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
import 'package:zibzo/features/zibzo/domain/usecases/home_page/product_use_case.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/bloc/product_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/cubit/add_cart/add_cart_cubit.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/screen/home_view.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/home_loading_widget.dart';

import '../../../../constants/product_params.dart';

class MockAppLocalStorage extends Mock implements AppLocalStorage {}

class MockProductsUseCase extends Mock implements ProductUseCase {}

class MockCartUseCase extends Mock implements AddCartUseCase {}

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

class MockCartCubit extends MockCubit<AddCartState> implements AddCartCubit {}

class FakeProductState extends Fake implements ProductState {}

class FakeProductEvent extends Fake implements ProductEvent {}

void main() {
  late MockAppLocalStorage mockAppLocalStorage;
  late MockProductsUseCase mockSignInUseCase;
  late MockCartUseCase mockCartUseCase;
  late MockCartCubit mockCartCubit;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = null; // Prevents real network requests

    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
    registerFallbackValue(FakeProductState());
    registerFallbackValue(FakeProductEvent());
  });

  setUp(() {
    sl.reset();
    mockAppLocalStorage = MockAppLocalStorage();
    mockSignInUseCase = MockProductsUseCase();

    mockCartUseCase = MockCartUseCase();
    mockCartCubit = MockCartCubit();
    HttpOverrides.global = null; // Prevents real network requests
    sl.registerLazySingleton<AppLocalStorage>(() => mockAppLocalStorage);
    sl.registerLazySingleton<ProductUseCase>(() => mockSignInUseCase);
    sl.registerLazySingleton<AddCartCubit>(() => mockCartCubit);
    when(() => mockAppLocalStorage.getCredential("image"))
        .thenAnswer((_) async => '');

    when(() => mockAppLocalStorage.getCredential("userName"))
        .thenAnswer((_) async => 'John Doe');

    when(() => mockCartCubit.state).thenReturn(AddCartInitial());
  });
  testWidgets("renders HomeLoadingWidget when ProductState is ProductLoading",
      (WidgetTester tester) async {
    final mockProductBloc = MockProductBloc();

    when(() => mockProductBloc.state).thenReturn(ProductLoading());

    final widget = HomeView();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ProductBloc>(
            create: (context) => mockProductBloc,
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
          home: widget,
        ),
      ),
    );

    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(HomeLoadingWidget), findsOneWidget);
  });

  testWidgets("success", (WidgetTester tester) async {
    final mockProductBloc = MockProductBloc();
    when(() => mockProductBloc.state).thenReturn(
      ProductLoaded(product: tHomeResponseEntity), // Desired state
    );

    final widget = HomeView();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ProductBloc>(
            create: (context) => mockProductBloc,
          ),
          ChangeNotifierProvider<CartCountProvider>(
            create: (context) => CartCountProvider(),
          ),
          BlocProvider<AddCartCubit>(
            create: (context) => AddCartCubit(mockCartUseCase),
          ),
        ],
        child: MaterialApp(title: 'Widget Test', home: widget),
      ),
    );

    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(HomeContent), findsOneWidget);
  });
}
