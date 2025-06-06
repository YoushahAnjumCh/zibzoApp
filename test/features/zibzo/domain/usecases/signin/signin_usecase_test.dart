import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo/features/zibzo/domain/repositories/signup/signup_repository.dart';
import 'package:zibzo/features/zibzo/domain/usecases/signin/signin_usecase.dart';

import '../../../../constants/signin_params.dart';
import '../../../../constants/signup_params.dart';

class MockSignRepository extends Mock implements UserRepository {}

void main() {
  late MockSignRepository repository;
  late SignInUseCase useCase;

  setUpAll(() {
    repository = MockSignRepository();
    useCase = SignInUseCase(repository);
  });
  test("Should return User from repository when signin called", () async {
    //Arrange
    when(() => repository.signin(tSignInParams))
        .thenAnswer((_) async => const Right(tUser));
    //Act
    final result = await useCase(tSignInParams);
    //Assert
    expect(result, const Right(tUser));
  });
}
