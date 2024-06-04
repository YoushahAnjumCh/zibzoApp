import 'package:either_dart/either.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/signup/user.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signin/signin_usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> signUp(SignUpParams params);
  Future<Either<Failure, User>> signin(SignInParams params);
}
