import 'dart:developer';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/core/network_info/network_info.dart';
import 'package:zibzo_app/core/typedef/typedef.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/auth/remote/user_remote_data_sources.dart';
import 'package:zibzo_app/features/zibzo/data/models/auth/user_model.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/signup/signup_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signin/signin_usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  UserRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  ResultVoid signUp(SignUpParams params) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signUp(params);
        return const Right(null);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(e.errorMessage.toString(), e.errorCode));
      } on SocketException catch (e) {
        return Left(ServerFailure(e.message, 500));
      }
    } else {
      return const Left(ConnectionFailure(StringConstant.kInternetFailureText));
    }
  }

  @override
  ResultFuture<UserModel> signin(SignInParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.signIn(params);
        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(e.errorMessage.toString(), e.errorCode));
      } on SocketException catch (e) {
        return Left(ServerFailure(e.message, 500));
      }
    } else {
      return const Left(ConnectionFailure(StringConstant.kInternetFailureText));
    }
  }
}
