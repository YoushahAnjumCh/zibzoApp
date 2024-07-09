import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/bloc/signup/signup_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/bloc/signup/signup_state.dart';

import '../../../../constants/signup_params.dart';

class MockUserUseCase extends Mock implements SignUpUseCase {}

void main() {
  late UserBloc userBloc;
  late MockUserUseCase useCase;

  setUpAll(() {
    useCase = MockUserUseCase();
    userBloc = UserBloc(useCase);
  });

  test("initial state should be User Initial", () {
    expect(userBloc.state, UserInitial());
  });
  blocTest<UserBloc, UserState>(
    "emit[UserLoading, UserLogged] when user click SignUpButton",
    build: () {
      final userBloc = UserBloc(useCase);
      when(() => useCase(tSignUpParams))
          .thenAnswer((_) async => const Right(tUser));
      return userBloc;
    },
    act: (bloc) => bloc.add(const SignupUser(tSignUpParams)),
    expect: () => [UserLoading(), UserLogged()],
  );

  blocTest<UserBloc, UserState>(
    "emit[UserLoading, UserLoggedFail] when user click SignUpButton",
    build: () {
      final userBloc = UserBloc(useCase);
      when(() => useCase(tSignUpParams)).thenAnswer(
          (_) async => const Left(ServerFailure("errorMessage", 401)));
      return userBloc;
    },
    act: (bloc) => bloc.add(const SignupUser(tSignUpParams)),
    expect: () => [UserLoading(), UserLoggedFail("Unauthorized: ")],
  );

  blocTest<UserBloc, UserState>(
    "emit[ ServerFailure] when user click SignUpButton",
    build: () {
      final userBloc = UserBloc(useCase);
      when(() => useCase(tSignUpParams))
          .thenThrow(const ServerFailure("", 500));
      return userBloc;
    },
    act: (bloc) => bloc.add(const SignupUser(tSignUpParams)),
    expect: () => [UserLoading(), UserLoggedFail("Internal Server Error: ")],
  );
}
