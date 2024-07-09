import 'dart:developer';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/core/network_info/network_info.dart';
import 'package:zibzo_app/core/typedef/typedef.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/products/product_remote_data_source.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/products/products.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/product/product_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/home_page/product_use_case.dart';

class ProductRepositoryImpl implements ProductRepository {
  final NetworkInfo networkInfo;
  final ProductDataSource dataSource;

  ProductRepositoryImpl({required this.dataSource, required this.networkInfo});

  @override
  ResultFuture<List<Products>> getProducts(ProductsParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await dataSource.getProducts(params);
        return Right(products);
      } on ServerFailure catch (e) {
        log(e.errorMessage.toString());
        return Left(ServerFailure(e.errorMessage.toString(), e.errorCode));
      } on SocketException catch (e) {
        log(e.message.toString());
        return Left(ServerFailure(e.message, 500));
      }
    } else {
      return Left(ConnectionFailure(StringConstant.kInternetFailureText));
    }
  }

  @override
  ResultFuture<Products> getProductById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await dataSource.getProductById(id);
        return Right(products);
      } on ServerFailure catch (e) {
        log(e.errorMessage.toString());
        return Left(ServerFailure(e.errorMessage.toString(), e.errorCode));
      } on SocketException catch (e) {
        log(e.message.toString());
        return Left(ServerFailure(e.message, 500));
      }
    } else {
      return Left(ConnectionFailure(StringConstant.kInternetFailureText));
    }
  }
}
