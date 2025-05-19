import 'package:either_dart/either.dart';

import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/core/usecase/usecase.dart';
import 'package:zibzo/features/zibzo/domain/entities/signup/user.dart';
import 'package:zibzo/features/zibzo/domain/repositories/signup/signup_repository.dart';

class SignInUseCase implements UseCase<User, SignInParams> {
  final UserRepository repository;
  SignInUseCase(
    this.repository,
  );

  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    return await repository.signin(params);
  }
}

class SignInParams {
  final String email;
  final String password;
  const SignInParams({
    required this.email,
    required this.password,
  });
}
