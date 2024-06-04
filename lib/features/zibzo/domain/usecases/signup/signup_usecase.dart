import 'package:either_dart/either.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/core/usecase/usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/signup/signup_repository.dart';

class SignUpUseCase implements UseCase<void, SignUpParams> {
  final UserRepository repository;
  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SignUpParams params) async {
    return await repository.signUp(params);
  }
}

class SignUpParams {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  const SignUpParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}
