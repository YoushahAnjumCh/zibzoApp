import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/domain/usecases/signup/signup_usecase.dart';
import 'package:zibzo/features/zibzo/presentation/signup/bloc/signup_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/signup/bloc/signup_state.dart';
import 'package:zibzo/features/zibzo/presentation/signup/screen/sign_up_screen.dart';

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
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
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

    expect(find.text(StringConstant.letsMakeAccount), findsOneWidget);
  });
}
