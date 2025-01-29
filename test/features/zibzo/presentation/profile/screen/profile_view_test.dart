import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo/core/constant/assets_path.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/presentation/profile/screen/profile_view.dart';
import 'package:zibzo/features/zibzo/presentation/profile/widgets/profile_details_widget.dart';
import 'package:zibzo/features/zibzo/presentation/profile/widgets/profile_items_widget.dart';
import 'package:zibzo/features/zibzo/presentation/profile/widgets/profile_logout_widget.dart';

class MockAppLocalStorage extends Mock implements AppLocalStorage {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockAppLocalStorage mockAppLocalStorage;
  late MockGoRouter mockGoRouter;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  setUp(() async {
    sl.reset();
    init();

    mockGoRouter = MockGoRouter();
    mockAppLocalStorage = MockAppLocalStorage();

    if (sl.isRegistered<AppLocalStorage>()) {
      sl.unregister<AppLocalStorage>();
    }

    sl.registerLazySingleton<AppLocalStorage>(() => mockAppLocalStorage);
    await sl.allReady(); // ✅ Ensure services are available

    when(() => mockAppLocalStorage.getCredential("image"))
        .thenAnswer((_) async => '');
    when(() => mockAppLocalStorage.getCredential("userName"))
        .thenAnswer((_) async => 'John Doe');
    when(() => mockAppLocalStorage.getCredential("email"))
        .thenAnswer((_) async => 'john@gmail.com');
    when(() => mockGoRouter.go(any())).thenReturn(null);
  });
  testWidgets('renders ProfileView with all items',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProfileView(),
      ),
    );

    expect(find.byType(ProfileDetailsWidget), findsOneWidget);

    expect(find.byType(ProfileItemsWidget), findsNWidgets(8));

    expect(find.byType(ProfileLogoutWidget), findsOneWidget);

    expect(find.text("Privacy Policy | Terms and Conditions"), findsOneWidget);
  });
  testWidgets('render ProfileDetailsWidget with user details',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ProfileDetailsWidget()),
      ),
    );

    await tester.pumpAndSettle();

    final circleAvatarFinder = find.byType(CircleAvatar);
    expect(circleAvatarFinder, findsOneWidget);

    final CircleAvatar avatar = tester.widget(circleAvatarFinder);
    expect(
        (avatar.backgroundImage as AssetImage).assetName, AssetsPath.appLogo);

    expect(find.text('John Doe'), findsOneWidget);

    expect(find.text('john@gmail.com'), findsOneWidget);
  });

  testWidgets('should navigate to login route on logout tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProfileView(),
      ),
    );

    final logoutButton = find.byKey(Key("LogoutKey"));
    expect(logoutButton, findsOneWidget);

    await tester.tap(logoutButton);
    await tester.pumpAndSettle();
  });
}
