import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/core/network_info/network_info.dart';
import 'package:zibzo_app/core/typedef/typedef.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/products/product_remote_data_source.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_response_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/home/home_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final NetworkInfo networkInfo;
  final ProductDataSource dataSource;

  ProductRepositoryImpl({required this.dataSource, required this.networkInfo});

  @override
  ResultFuture<HomeResponseEntity> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final products = await dataSource.getProducts();
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
