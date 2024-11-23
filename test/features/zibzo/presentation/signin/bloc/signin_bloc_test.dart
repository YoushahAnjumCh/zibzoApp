import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signin/signin_usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_event.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_state.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/bloc/signup/signup_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/bloc/signup/signup_state.dart';

import '../../../../constants/signin_params.dart';
import '../../../../constants/signup_params.dart';

class MockUserUseCase extends Mock implements SignInUseCase {}

void main() {
  late SignInBloc userBloc;
  late MockUserUseCase useCase;

  setUpAll(() {
    useCase = MockUserUseCase();
    userBloc = SignInBloc(useCase);
  });

  test("initial state should be User Initial", () {
    expect(userBloc.state, SignInInitial());
  });
  blocTest<SignInBloc, SignInState>(
    "emit[SignInLoading, SignInSuccess] when user click SignInButton",
    build: () {
      final userBloc = SignInBloc(useCase);
      when(() => useCase(tSignInParams))
          .thenAnswer((_) async => const Right(tUser));
      return userBloc;
    },
    act: (bloc) => bloc.add(SignInButtonEvent(params: tSignInParams)),
    expect: () => [SignInLoading(), SignInSuccess(user: tUser)],
  );

  blocTest<SignInBloc, SignInState>(
    "emit[SignInLoading, SignInFail] when user click SignInButton",
    build: () {
      final userBloc = SignInBloc(useCase);
      when(() => useCase(tSignInParams)).thenAnswer(
          (_) async => const Left(ServerFailure("errorMessage", 401)));
      return userBloc;
    },
    act: (bloc) => bloc.add(SignInButtonEvent(params: tSignInParams)),
    expect: () => [SignInLoading(), SignInFail(message: "errorMessage")],
  );

  blocTest<SignInBloc, SignInState>(
    "emit[ServerFailure] when user click SignInButton",
    build: () {
      final userBloc = SignInBloc(useCase);
      when(() => useCase(tSignInParams))
          .thenThrow(const ServerFailure("Internal Server Error: ", 500));
      return userBloc;
    },
    act: (bloc) => bloc.add(SignInButtonEvent(params: tSignInParams)),
    expect: () =>
        [SignInLoading(), SignInFail(message: "Internal Server Error: ")],
  );
}
