import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/shared_preferences/shared_preferences_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_cubit.dart';
import 'package:zibzo_app/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_state.dart';

class MockSharedPreferencesLoginUseCase extends Mock
    implements SharedPreferencesLoginUseCase {}

class MockSharedPreferencesLoginStatusUseCase extends Mock
    implements SharedPreferencesLoginStatusUseCase {}

class MockSharedPreferencesLogoutUseCase extends Mock
    implements SharedPreferencesLogoutUseCase {}

void main() {
  late SharedPreferencesCubit cubit;
  late MockSharedPreferencesLoginUseCase mockLoginUseCase;
  late MockSharedPreferencesLoginStatusUseCase mockLoginStatusUseCase;
  late MockSharedPreferencesLogoutUseCase mockLogoutUseCase;

  setUp(() {
    mockLoginUseCase = MockSharedPreferencesLoginUseCase();
    mockLoginStatusUseCase = MockSharedPreferencesLoginStatusUseCase();
    mockLogoutUseCase = MockSharedPreferencesLogoutUseCase();
    cubit = SharedPreferencesCubit(
      mockLoginStatusUseCase,
      mockLoginUseCase,
      mockLogoutUseCase,
    );
  });

  group('SharedPreferencesCubit', () {
    blocTest<SharedPreferencesCubit, AuthState>(
      'emits [Authenticated] when login status is true',
      setUp: () {
        when(() => mockLoginStatusUseCase.isLoggedIn()).thenAnswer(
          (_) async => true,
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.checkLoginStatus(),
      expect: () => [Authenticated()],
    );

    blocTest<SharedPreferencesCubit, AuthState>(
      'emits [Unauthenticated] when login status is false',
      setUp: () {
        when(() => mockLoginStatusUseCase.isLoggedIn()).thenAnswer(
          (_) async => false,
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.checkLoginStatus(),
      expect: () => [Unauthenticated()],
    );

    blocTest<SharedPreferencesCubit, AuthState>(
      'emits [Authenticated] when login is called',
      setUp: () {
        when(() => mockLoginUseCase.logIn(any(), any()))
            .thenAnswer((_) async => {});
      },
      build: () => cubit,
      act: (cubit) => cubit.login('testUser', 'testKey'),
      expect: () => [Authenticated()],
      verify: (_) {
        verify(() => mockLoginUseCase.logIn('testKey', 'testUser')).called(1);
      },
    );

    blocTest<SharedPreferencesCubit, AuthState>(
      'emits [Unauthenticated] when logout is called',
      setUp: () {
        when(() => mockLogoutUseCase.logOut(any())).thenAnswer((_) async => {});
      },
      build: () => cubit,
      act: (cubit) => cubit.logout('testKey'),
      expect: () => [Unauthenticated()],
      verify: (_) {
        verify(() => mockLogoutUseCase.logOut('testKey')).called(1);
      },
    );
  });
}
