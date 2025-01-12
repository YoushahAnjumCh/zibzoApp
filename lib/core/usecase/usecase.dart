import 'package:either_dart/either.dart';
import 'package:zibzo/core/failure/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}
