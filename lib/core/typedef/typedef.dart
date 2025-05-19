import 'package:either_dart/either.dart';

import '../failure/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultVoid = ResultFuture<void>;

typedef ResultStream<T> = Stream<Either<Failure, T>>;
