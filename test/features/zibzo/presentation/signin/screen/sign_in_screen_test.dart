import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/constant/widgets_keys.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/domain/usecases/signin/signin_usecase.dart';
import 'package:zibzo/features/zibzo/presentation/signin/bloc/signin_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/signin/bloc/signin_event.dart';
import 'package:zibzo/features/zibzo/presentation/signin/bloc/signin_state.dart';
import 'package:zibzo/features/zibzo/presentation/signin/screen/sign_in_screen.dart';

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

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
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
}
