import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:zibzo/common/provider/cart_count_provider.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/domain/entities/cart/cart_response_entity.dart';
import 'package:zibzo/features/zibzo/presentation/cart/bloc/bloc/cart_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/cart/view/cart_screen.dart';
import 'package:zibzo/firebase/analytics/firebase_analytics.dart';

import '../../../../constants/product_params.dart';

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}

class MockAppLocalStorage extends Mock implements AppLocalStorage {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

class FakeCartState extends Fake implements CartState {}

class FakeCartEvent extends Fake implements CartEvent {}

void main() {
  late MockAnalyticsService mockAnalyticsService;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();

    registerFallbackValue(FakeCartState());
  });

  setUp(() {
    sl.reset();
    sl.registerLazySingleton<AppLocalStorage>(() => MockAppLocalStorage());
    mockAnalyticsService = MockAnalyticsService();
    sl.registerLazySingleton<AnalyticsService>(() => mockAnalyticsService);
  });

  testWidgets("Cart screen success", (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      final params =
          CartResponseEntity(cartProductCount: 1, products: tProducts);

      final mockCartBloc = MockCartBloc();
      when(() => mockCartBloc.state).thenReturn(
        CartSuccess(cartResponseEntity: params),
      );

      when(() => mockAnalyticsService.logScreensView(
            'cart_screen',
            'CartScreen',
          )).thenAnswer((_) async {
        return Future.value();
      });

      final widget = CartScreen();

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CartBloc>(
              create: (context) => mockCartBloc,
            ),
            ChangeNotifierProvider<CartCountProvider>(
              create: (context) => CartCountProvider(),
            ),
          ],
          child: MaterialApp(title: 'Widget Test', home: widget),
        ),
      );

      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(CartScreen), findsOneWidget);
    });
  });

  testWidgets("Cart Screen failure", (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      final mockCartBloc = MockCartBloc();

      when(() => mockCartBloc.state).thenReturn(
        CartFailure(message: "Failed to load cart data"),
      );

      final widget = CartScreen();

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CartBloc>(
              create: (context) => mockCartBloc,
            ),
            ChangeNotifierProvider<CartCountProvider>(
              create: (context) => CartCountProvider(),
            ),
          ],
          child: MaterialApp(title: 'Widget Test', home: widget),
        ),
      );

      await tester.pump(const Duration(seconds: 4));

      expect(find.text("Failed to load cart data"), findsOneWidget);
      expect(find.byType(CartScreen), findsOneWidget);
    });
  });
}
