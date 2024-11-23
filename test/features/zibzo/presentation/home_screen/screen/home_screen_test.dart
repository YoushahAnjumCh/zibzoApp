import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:zibzo_app/common/bottom_nav_bar_notifier.dart';
import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo_app/core/service/service_locator.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/home_page/product_use_case.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/bloc/product_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/screen/home_screen.dart';
import 'package:zibzo_app/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_cubit.dart';
import 'package:zibzo_app/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_state.dart';

import '../../../../constants/product_params.dart';

class MockAppLocalStorage extends Mock implements AppLocalStorage {}

class MockProductsUseCase extends Mock implements ProductUseCase {}

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

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
  setUpAll(() {
    registerFallbackValue(FakeCategoryProductState());
    registerFallbackValue(FakeCategoryProductEvent());
    registerFallbackValue(FakeAuthState());
  });
  setUp(() {
    mockSharedPreferencesCubit = MockSharedPreferencesCubit();

    bottomNavBarNotifier = BottomNavBarNotifier();
    mockAppLocalStorage = MockAppLocalStorage();
    mockProductsUseCase = MockProductsUseCase();
    sl.registerLazySingleton<AppLocalStorage>(() => mockAppLocalStorage);
    sl.registerLazySingleton<SharedPreferencesCubit>(
        () => mockSharedPreferencesCubit);
    when(() => mockAppLocalStorage.getToken("image"))
        .thenAnswer((_) async => 'https://via.placeholder.com/150');

    when(() => mockAppLocalStorage.getToken("userName"))
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
        Provider<ProductBloc>(
          create: (_) => ProductBloc(mockProductsUseCase),
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
    when(() => mockAuthenticationBloc.state).thenReturn(
        ProductLoaded(product: tHomeResponseEntity) // the desired state
        );

    await tester.pumpWidget(createWidgetUnderTest());

    // Simulate the bloc emitting a new state
    // bloc.emit(mockState);
    await tester.pumpAndSettle();
  });
}
