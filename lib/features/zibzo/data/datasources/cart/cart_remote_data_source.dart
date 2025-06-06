import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/data/models/cart/cart_count_model.dart';
import 'package:zibzo/features/zibzo/data/models/cart/cart_response_model.dart';
import 'package:zibzo/features/zibzo/domain/usecases/cart/add_cart_usecase.dart';
import 'package:zibzo/features/zibzo/domain/usecases/cart/delete_cart_usecase.dart';

abstract class CartDataSource {
  Future<CartCountModel> addCart(AddCartParams params);
  Future<CartResponseModel> getCart();
  Future<CartResponseModel> removeCart(DeleteCartParams params);
}

class CartRemoteDataSourceImpl implements CartDataSource {
  final http.Client client;
  CartRemoteDataSourceImpl({required this.client});
  final AppLocalStorage appSecureStorage = sl<AppLocalStorage>();

  @override
  Future<CartCountModel> addCart(AddCartParams params) async {
    final token =
        await appSecureStorage.getCredential(StringConstant.authToken);
    final userID = await appSecureStorage.getCredential(StringConstant.userID);

    final response =
        await client.post(Uri.parse('${StringConstant.kBaseUrl}cart'), body: {
      "userID": userID,
      "productID": params.productId,
    }, headers: {
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == StringConstant.k201) {
      return CartCountModel.fromJson(jsonDecode(response.body));
    } else {
      final errorMessage = json.decode(response.body);

      throw ServerFailure(errorMessage['message'], response.statusCode);
    }
  }

  @override
  Future<CartResponseModel> getCart() async {
    final token =
        await appSecureStorage.getCredential(StringConstant.authToken);
    final userID = await appSecureStorage.getCredential(StringConstant.userID);

    final response = await client.get(
        Uri.parse('${StringConstant.kBaseUrl}cart?userID=$userID'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == StringConstant.k200) {
      return CartResponseModel.fromJson(jsonDecode(response.body));
    } else {
      final errorMessage = json.decode(response.body);
      throw ServerFailure(errorMessage['message'], response.statusCode);
    }
  }

  @override
  Future<CartResponseModel> removeCart(DeleteCartParams params) async {
    final token =
        await appSecureStorage.getCredential(StringConstant.authToken);
    final userID = await appSecureStorage.getCredential(StringConstant.userID);

    final response =
        await client.delete(Uri.parse('${StringConstant.kBaseUrl}cart'), body: {
      "userID": userID,
      "productID": params.productID,
    }, headers: {
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == StringConstant.k200) {
      return CartResponseModel.fromJson(jsonDecode(response.body));
    } else {
      final errorMessage = json.decode(response.body);
      throw ServerFailure(errorMessage['message'], response.statusCode);
    }
  }
}
