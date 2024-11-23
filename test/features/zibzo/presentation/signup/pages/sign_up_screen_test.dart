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
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_event.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_state.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/screen/sign_in_screen.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/bloc/signup/signup_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/bloc/signup/signup_state.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/pages/sign_up_screen.dart';

// Mock dependencies
class MockAppLocalStorage extends Mock implements AppLocalStorage {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockSignUpBloc extends MockBloc<UserEvent, UserState>
    implements UserBloc {}

void main() {
  late MockAppLocalStorage mockAppLocalStorage;
  late MockSignUpUseCase mockSignUpUseCase;
  late UserBloc signUpBloc;
  late MockSignUpBloc mockSignUpBloc;

  // Setup fallback values and mock dependencies
  setUpAll(() {
    registerFallbackValue(
      SignupUser(SignUpParams(
          userName: "userName",
          email: "email@gmail.com",
          password: "password")),
    );
  });

  setUp(() {
    sl.reset();
    mockAppLocalStorage = MockAppLocalStorage();
    mockSignUpUseCase = MockSignUpUseCase();
    signUpBloc = UserBloc(mockSignUpUseCase);
    mockSignUpBloc = MockSignUpBloc();
    sl.registerLazySingleton<AppLocalStorage>(() => mockAppLocalStorage);
    sl.registerLazySingleton<SignUpUseCase>(() => mockSignUpUseCase);
    when(() => mockSignUpBloc.state).thenReturn(UserInitial());
    when(() => mockSignUpBloc.stream).thenAnswer(
      (_) => Stream.value(UserInitial()), // Stream emitting SignInInitial
    );
  });

  tearDown(() {
    signUpBloc.close();
    mockSignUpBloc.close();
  });

  // Test cases
  testWidgets('SignInScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [BlocProvider(create: (_) => signUpBloc)],
        child: MaterialApp(home: SignUpScreen()),
      ),
    );

    // Verify UI elements
    // expect(find.byKey(Key(WidgetsKeys.tEmailKey)), findsOneWidget);
    // expect(find.byKey(Key(WidgetsKeys.tPasswordKey)), findsOneWidget);
    // expect(find.byKey(Key(WidgetsKeys.tSigninKey)), findsOneWidget);
    // expect(find.text(StringConstant.dontHaveAccount), findsOneWidget);
    expect(find.text(StringConstant.welcomeSignUp), findsOneWidget);
  });
}
