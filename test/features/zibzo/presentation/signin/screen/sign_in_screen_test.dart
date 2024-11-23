import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/constant/widgets_keys.dart';
import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo_app/core/service/service_locator.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signin/signin_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_event.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_state.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/screen/sign_in_screen.dart';

// Mock dependencies
class MockAppLocalStorage extends Mock implements AppLocalStorage {}

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockSignInBloc extends MockBloc<SignInEvent, SignInState>
    implements SignInBloc {}

void main() {
  late MockAppLocalStorage mockAppLocalStorage;
  late MockSignInUseCase mockSignInUseCase;
  late SignInBloc signInBloc;
  late MockSignInBloc mockSignInBloc;

  // Setup fallback values and mock dependencies
  setUpAll(() {
    registerFallbackValue(
      SignInButtonEvent(params: SignInParams(email: "", password: "")),
    );
  });

  setUp(() {
    sl.reset();
    mockAppLocalStorage = MockAppLocalStorage();
    mockSignInUseCase = MockSignInUseCase();
    signInBloc = SignInBloc(mockSignInUseCase);
    mockSignInBloc = MockSignInBloc();
    sl.registerLazySingleton<AppLocalStorage>(() => mockAppLocalStorage);
    sl.registerLazySingleton<SignInUseCase>(() => mockSignInUseCase);
    when(() => mockSignInBloc.state).thenReturn(SignInInitial());
    when(() => mockSignInBloc.stream).thenAnswer(
      (_) => Stream.value(SignInInitial()), // Stream emitting SignInInitial
    );
  });

  tearDown(() {
    signInBloc.close();
    mockSignInBloc.close();
  });

  // Test cases
  testWidgets('SignInScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [BlocProvider(create: (_) => signInBloc)],
        child: MaterialApp(home: SignInScreen()),
      ),
    );

    // Verify UI elements
    expect(find.byKey(Key(WidgetsKeys.tEmailKey)), findsOneWidget);
    expect(find.byKey(Key(WidgetsKeys.tPasswordKey)), findsOneWidget);
    expect(find.byKey(Key(WidgetsKeys.tSigninKey)), findsOneWidget);
    expect(find.text(StringConstant.dontHaveAccount), findsOneWidget);
    expect(find.text(StringConstant.register), findsOneWidget);
  });

  // testWidgets('Displays error message on login failure',
  //     (WidgetTester tester) async {
  //   when(() => signInBloc.stream).thenAnswer(
  //     (_) => Stream.value(SignInFail(message: 'Invalid credentials')),
  //   );
  //   when(() => signInBloc.state)
  //       .thenReturn(SignInFail(message: 'Invalid credentials'));

  //   await tester.pumpWidget(
  //     MultiBlocProvider(
  //       providers: [BlocProvider(create: (_) => signInBloc)],
  //       child: MaterialApp(home: SignInScreen()),
  //     ),
  //   );

  //   await tester.pumpAndSettle();

  //   // Verify the error message is displayed
  //   expect(find.text('Invalid credentials'), findsOneWidget);
  // });

  // testWidgets('Shows loading and dismisses after login',
  //     (WidgetTester tester) async {
  //   when(() => signInBloc.stream).thenAnswer(
  //     (_) => Stream.fromIterable([
  //       SignInLoading(),
  //       SignInSuccess(
  //           user: User(
  //               token: "token", userName: "", email: "", id: "", image: "")),
  //     ]),
  //   );
  //   when(() => signInBloc.state).thenReturn(SignInLoading());

  //   await tester.pumpWidget(
  //     MultiBlocProvider(
  //       providers: [BlocProvider(create: (_) => signInBloc)],
  //       child: MaterialApp(home: SignInScreen()),
  //     ),
  //   );

  //   // Verify loading indicator is displayed
  //   expect(find.byType(CircularProgressIndicator), findsOneWidget);

  //   await tester.pumpAndSettle();

  //   // Verify loading indicator is dismissed
  //   expect(find.byType(CircularProgressIndicator), findsNothing);
  // });

  // testWidgets('Saves token and navigates to home on successful login',
  //     (WidgetTester tester) async {
  //   final user = User(
  //     token: 'token123',
  //     image: 'image_url',
  //     userName: 'testUser',
  //     email: "",
  //     id: "",
  //   );

  //   when(() => mockAppLocalStorage.saveToken(any(), any()))
  //       .thenAnswer((_) async => {});
  //   when(() => signInBloc.stream).thenAnswer(
  //     (_) => Stream.value(SignInSuccess(user: user)),
  //   );
  //   // when(() => signInBloc.state).thenReturn(SignInInitial());

  //   await tester.pumpWidget(
  //     MultiBlocProvider(
  //       providers: [BlocProvider(create: (_) => signInBloc)],
  //       child: MaterialApp(home: SignInScreen()),
  //     ),
  //   );

  //   await tester.pumpAndSettle();

  //   // Verify token is saved
  //   verify(() => mockAppLocalStorage.saveToken('token', 'token123')).called(1);

  //   // Add navigation verification logic here if applicable
  // });

  // testWidgets('Triggers sign-in event on button click with valid input',
  //     (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: BlocProvider<SignInBloc>(
  //         create: (_) => signInBloc,
  //         child: SignInScreen(), // SignInScreen is now correctly wrapped
  //       ),
  //     ),
  //   );

  //   await tester.enterText(
  //       find.byKey(Key(WidgetsKeys.tEmailKey)), 'test@example.com');
  //   await tester.enterText(
  //       find.byKey(Key(WidgetsKeys.tPasswordKey)), 'password123');
  //   await tester.tap(find.byKey(Key(WidgetsKeys.tSigninKey)));
  //   await tester.pumpAndSettle();

  //   verify(() => signInBloc.add(
  //         SignInButtonEvent(
  //           params: SignInParams(
  //               email: 'test@example.com', password: 'password123'),
  //         ),
  //       )).called(1);
  // });

  // testWidgets('Saves token and navigates to home on successful login',
  //     (WidgetTester tester) async {
  //   final user = User(
  //       token: 'token123',
  //       image: 'image_url',
  //       userName: 'testUser',
  //       email: "",
  //       id: "");

  //   // when(() => mockAppLocalStorage.saveToken(any(), any()))
  //   //     .thenAnswer((_) async => {});
  //   when(() => signInBloc.stream).thenAnswer(
  //     (_) => Stream.value(SignInSuccess(user: user)),
  //   );

  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: BlocProvider<SignInBloc>(
  //         create: (_) => signInBloc,
  //         child: SignInScreen(), // SignInScreen is now correctly wrapped
  //       ),
  //     ),
  //   );
  //   await tester.pumpAndSettle();

  //   verify(() => mockAppLocalStorage.saveToken('token', 'token123')).called(1);

  //   // Add navigation verification if needed, e.g., checking the route
  //   // expect(find.byType(HomeScreen), findsOneWidget);
  // });
}
