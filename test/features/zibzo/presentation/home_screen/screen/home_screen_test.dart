import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:zibzo/common/bottom_nav_bar_notifier.dart';
import 'package:zibzo/common/provider/cart_count_provider.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/domain/entities/cart/cart_response_entity.dart';
import 'package:zibzo/features/zibzo/domain/usecases/cart/delete_cart_usecase.dart';
import 'package:zibzo/features/zibzo/domain/usecases/cart/get_cart_usecase.dart';
import 'package:zibzo/features/zibzo/domain/usecases/home_page/product_use_case.dart';
import 'package:zibzo/features/zibzo/presentation/cart/bloc/bloc/cart_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/bloc/product_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/screen/home_screen.dart';
import 'package:zibzo/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_cubit.dart';
import 'package:zibzo/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_state.dart';

import '../../../../constants/product_params.dart';

class MockAppLocalStorage extends Mock implements AppLocalStorage {}

class MockProductsUseCase extends Mock implements ProductUseCase {}

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

class MockGetCartUseCase extends Mock implements GetCartUseCase {}

class MockDeleteCartUseCase extends Mock implements DeleteCartUseCase {}

class MockSharedPreferencesCubit extends MockCubit<AuthState>
    implements SharedPreferencesCubit {}

class FakeAuthState extends Fake implements AuthState {}

class FakeCategoryProductState extends Fake implements ProductState {}

class FakeCategoryProductEvent extends Fake implements ProductFetchEvent {}

void main() {
  late MockAppLocalStorage mockAppLocalStorage;
  late MockSharedPreferencesCubit mockSharedPreferencesCubit;
  late BottomNavBarNotifier bottomNavBarNotifier;
  late MockProductsUseCase mockProductsUseCase;
  late MockDeleteCartUseCase mockDeleteCartUseCase;
  late MockGetCartUseCase mockGetCartUseCase;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
    registerFallbackValue(FakeCategoryProductState());
    registerFallbackValue(FakeCategoryProductEvent());
    registerFallbackValue(FakeAuthState());
  });
  setUp(() {
    sl.reset();
    mockSharedPreferencesCubit = MockSharedPreferencesCubit();
    mockGetCartUseCase = MockGetCartUseCase();
    mockDeleteCartUseCase = MockDeleteCartUseCase();
    bottomNavBarNotifier = BottomNavBarNotifier();
    mockAppLocalStorage = MockAppLocalStorage();
    mockProductsUseCase = MockProductsUseCase();
    sl.registerLazySingleton<AppLocalStorage>(() => mockAppLocalStorage);
    sl.registerFactory<CartBloc>(
        () => CartBloc(mockDeleteCartUseCase, mockGetCartUseCase));

    sl.registerLazySingleton<SharedPreferencesCubit>(
        () => mockSharedPreferencesCubit);
    when(() => mockAppLocalStorage.getCredential("image"))
        .thenAnswer((_) async => 'https://via.placeholder.com/150');

    when(() => mockAppLocalStorage.getCredential("userName"))
        .thenAnswer((_) async => 'John Doe');
    when(() => mockSharedPreferencesCubit.state).thenReturn(Authenticated());
    when(() => mockSharedPreferencesCubit.sharedPreferencesLoginStatusUseCase
        .isLoggedIn()).thenAnswer((_) async => true);
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomNavBarNotifier>.value(
          value: bottomNavBarNotifier,
        ),
        BlocProvider<CartBloc>(
          create: (_) => CartBloc(mockDeleteCartUseCase, mockGetCartUseCase),
        ),
        Provider<ProductBloc>(
          create: (_) => ProductBloc(mockProductsUseCase),
        ),
        ChangeNotifierProvider<CartCountProvider>(
          create: (context) => CartCountProvider(),
        ),
        BlocProvider<SharedPreferencesCubit>(
          create: (context) => mockSharedPreferencesCubit,
        ),
      ],
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  testWidgets("Displays HomeView as the initial view",
      (WidgetTester tester) async {
    // Mocking user data
    WidgetsFlutterBinding.ensureInitialized();

    final mockAuthenticationBloc = MockProductBloc();
    when(() => mockAuthenticationBloc.state)
        .thenReturn(ProductLoaded(product: tHomeResponseEntity));

    when(() => mockGetCartUseCase.call()).thenAnswer(
      (_) async =>
          Right(CartResponseEntity(products: [tProduct], cartProductCount: 1)),
    );

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.pumpAndSettle();
  });
}
