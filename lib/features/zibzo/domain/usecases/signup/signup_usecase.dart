import 'package:zibzo_app/core/typedef/typedef.dart';
import 'package:zibzo_app/core/usecase/usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/signup/signup_repository.dart';

class SignUpUseCase implements UseCase<void, SignUpParams> {
  final UserRepository repository;
  SignUpUseCase(this.repository);

  @override
  ResultVoid call(SignUpParams params) async {
    return await repository.signUp(params);
  }
}

class SignUpParams {
  final String userName;
  final String email;
  final String password;
  const SignUpParams({
    required this.userName,
    required this.email,
    required this.password,
  });
}
