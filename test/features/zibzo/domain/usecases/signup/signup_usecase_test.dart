import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/signup/signup_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';

import '../../../../constants/signup_params/signup_params.dart';

class MockRepository extends Mock implements UserRepository {}

void main() {
  late SignUpUseCase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = SignUpUseCase(mockRepository);
  });

  test(
    'Should get User from the repository when User Repository return data successfully',
    () async {
      /// Arrange
      when(() => mockRepository.signUp(tSignUpParams))
          .thenAnswer((_) async => const Right(tUser));

      /// Act
      final result = await usecase(tSignUpParams);

      /// Assert
      expect(result, const Right(tUser));
      verify(() => mockRepository.signUp(tSignUpParams));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return a Failure from the repository', () async {
    /// Arrange
    const failure = ConnectionFailure("network Failure");
    when(() => mockRepository.signUp(tSignUpParams))
        .thenAnswer((_) async => const Left(failure));

    /// Act
    final result = await usecase(tSignUpParams);

    /// Assert
    expect(result, const Left(failure));
    verify(() => mockRepository.signUp(tSignUpParams));
    verifyNoMoreInteractions(mockRepository);
  });

  test('Users Equatable test cases', () {
    const user1 = tUser;
    expect(user1.email, equals("email"));
  });
}
