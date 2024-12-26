import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/core/network_info/network_info.dart';
import 'package:zibzo_app/core/typedef/typedef.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/cart/cart_remote_data_source.dart';
import 'package:zibzo_app/features/zibzo/data/models/cart/cart_count_model.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/cart/cart_response_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/cart/cart_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/cart/add_cart_usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/cart/delete_cart_usecase.dart';

class CartRepositoryImpl implements CartRepository {
  final CartDataSource cartDataSource;
  final NetworkInfo networkInfo;

  CartRepositoryImpl({
    required this.cartDataSource,
    required this.networkInfo,
  });

  @override
  ResultFuture<CartCountModel> addCart(AddCartParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final cart = await cartDataSource.addCart(params);
        return Right(cart);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(e.errorMessage.toString(), e.errorCode));
      } on SocketException catch (e) {
        return Left(ServerFailure(e.message.toString(), 500));
      }
    } else {
      return Left(ConnectionFailure(StringConstant.kInternetFailureText));
    }
  }

  @override
  ResultFuture<CartResponseEntity> getCart() async {
    if (await networkInfo.isConnected) {
      try {
        final cart = await cartDataSource.getCart();
        return Right(cart);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(e.errorMessage.toString(), e.errorCode));
      } on SocketException catch (e) {
        return Left(ServerFailure(e.message.toString(), 500));
      }
    } else {
      return Left(ConnectionFailure(StringConstant.kInternetFailureText));
    }
  }

  @override
  ResultFuture<CartResponseEntity> removeCart(DeleteCartParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final cart = await cartDataSource.removeCart(params);
        return Right(cart);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(e.errorMessage.toString(), e.errorCode));
      } on SocketException catch (e) {
        return Left(ServerFailure(e.message.toString(), 500));
      }
    } else {
      return Left(ConnectionFailure(StringConstant.kInternetFailureText));
    }
  }
}
