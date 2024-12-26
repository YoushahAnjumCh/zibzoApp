import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:zibzo_app/common/provider/cart_count_provider.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/cart/cart_response_entity.dart';
import 'package:zibzo_app/features/zibzo/presentation/cart/bloc/bloc/cart_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/cart/view/cart_screen.dart';

import '../../../../constants/product_params.dart';

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}

class FakeCartState extends Fake implements CartState {}

class FakeCartEvent extends Fake implements CartEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCartState());
    registerFallbackValue(FakeCartState());
  });

  setUp(() {});

  testWidgets("Cart screen success", (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      WidgetsFlutterBinding.ensureInitialized();
      final params =
          CartResponseEntity(cartProductCount: 1, products: tProducts);

      final mockCartBloc = MockCartBloc();
      when(() => mockCartBloc.state).thenReturn(
        CartSuccess(cartResponseEntity: params), // Desired state
      );

      // Widget under test
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

      // Simulate async rebuild
      await tester.pump(const Duration(seconds: 4));

      // Verify expected output
      expect(find.byType(CartScreen), findsOneWidget);
    });
  });

  testWidgets("Cart Screen failure", (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      WidgetsFlutterBinding.ensureInitialized();

      final mockCartBloc = MockCartBloc();

      when(() => mockCartBloc.state).thenReturn(
        CartFailure(message: "Failed to load cart data"),
      );

      // Widget under test
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
