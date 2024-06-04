import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zibzo_app/core/constant/widgets_keys.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/screen/sign_in_screen.dart';

void main() {
  testWidgets('Shows success message if fields are filled',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignInScreen()));

    // Enter text in the email and password fields
    await tester.enterText(
        find.byKey(const Key(WidgetsKeys.tEmailKey)), 'test@example.com');
    await tester.enterText(
        find.byKey(const Key(WidgetsKeys.tPasswordKey)), '123123123');

    // Tap the login button
    await tester.tap(find.byKey(const Key(WidgetsKeys.tSigninKey)));
    await tester.pump();

    expect(SignInScreen(), findsOneWidget);
  });
}
