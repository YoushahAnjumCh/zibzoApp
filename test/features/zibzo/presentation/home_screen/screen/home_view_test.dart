import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo_app/core/service/service_locator.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/home_page/product_use_case.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/bloc/product_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/screen/home_view.dart';
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

class FakeProductState extends Fake implements ProductState {}

class FakeProductEvent extends Fake implements ProductEvent {}

void main() {
  late MockAppLocalStorage mockAppLocalStorage;
  late MockProductsUseCase mockSignInUseCase;
  late MockSharedPreferencesCubit mockSharedPreferencesCubit;
  setUpAll(() {
    registerFallbackValue(FakeProductState());
    registerFallbackValue(FakeProductEvent());
    registerFallbackValue(FakeAuthState());
  });

  setUp(() {
    mockAppLocalStorage = MockAppLocalStorage();
    mockSignInUseCase = MockProductsUseCase();
    mockSharedPreferencesCubit = MockSharedPreferencesCubit();
    sl.registerLazySingleton<AppLocalStorage>(() => mockAppLocalStorage);
    sl.registerLazySingleton<ProductUseCase>(() => mockSignInUseCase);
    sl.registerLazySingleton<SharedPreferencesCubit>(
        () => mockSharedPreferencesCubit);
    when(() => mockAppLocalStorage.getToken("image"))
        .thenAnswer((_) async => 'https://via.placeholder.com/150');

    when(() => mockAppLocalStorage.getToken("userName"))
        .thenAnswer((_) async => 'John Doe');
    // Mock SharedPreferencesCubit behavior
    when(() => mockSharedPreferencesCubit.state).thenReturn(Authenticated());
    when(() => mockSharedPreferencesCubit.sharedPreferencesLoginStatusUseCase
        .isLoggedIn()).thenAnswer((_) async => true);
  });

  testWidgets("success", (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Mock ProductBloc
    final mockProductBloc = MockProductBloc();
    when(() => mockProductBloc.state).thenReturn(
      ProductLoaded(product: tProductResponse), // Desired state
    );

    // Widget under test
    final widget = HomeView();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ProductBloc>(
            create: (context) => mockProductBloc,
          ),
          BlocProvider<SharedPreferencesCubit>(
            create: (context) => mockSharedPreferencesCubit,
          ),
        ],
        child: MaterialApp(title: 'Widget Test', home: widget),
      ),
    );

    // Simulate async rebuild
    await tester.pump(const Duration(seconds: 4));

    // Verify expected output
    expect(find.byType(HomeContent), findsOneWidget);
  });
}
