import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/core/network_info/network_info.dart';
import 'package:zibzo_app/core/typedef/typedef.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/category_products_data_source/category_prod_remote_data_source.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/category_products/category_products_repository.dart';

class CategoryProductsRepoImpl extends CategoryProductsRepository {
  final CategoryProductDataSource dataSource;
  final NetworkInfo networkInfo;
  CategoryProductsRepoImpl(
      {required this.dataSource, required this.networkInfo});

  @override
  ResultFuture<List<ProductEntity>> getCategoryProducts(
      String categoryName) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await dataSource.getCategoryProducts(categoryName);
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
