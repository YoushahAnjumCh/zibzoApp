import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/core/network_info/network_info.dart';
import 'package:zibzo/core/typedef/typedef.dart';
import 'package:zibzo/features/zibzo/data/datasources/search/search_remote_data_source.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo/features/zibzo/domain/repositories/search/search_repository.dart';
import 'package:zibzo/features/zibzo/domain/usecases/search/search_usecase.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchDataSource dataSource;
  final NetworkInfo networkInfo;
  SearchRepositoryImpl({required this.dataSource, required this.networkInfo});
  @override
  ResultFuture<List<ProductEntity>> searchProduct(
      SearchUseCaseParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await dataSource.searchProduct(params);
        return Right(products);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(e.errorMessage.toString(), e.errorCode));
      } on SocketException catch (e) {
        return Left(ServerFailure(e.message, 500));
      }
    } else {
      return Left(ConnectionFailure(StringConstant.kInternetFailureText));
    }
  }
}
