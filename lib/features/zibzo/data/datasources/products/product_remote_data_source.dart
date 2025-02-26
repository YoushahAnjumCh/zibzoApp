import 'dart:convert';

import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:http/http.dart' as http;
import 'package:zibzo/features/zibzo/data/models/products/product_response_model.dart';

abstract class ProductDataSource {
  Future<ProductResponseModel> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductDataSource {
  final http.Client client;
  ProductRemoteDataSourceImpl({required this.client});

  final AppLocalStorage appSecureStorage = sl<AppLocalStorage>();

  @override
  Future<ProductResponseModel> getProducts() async {
    final token =
        await appSecureStorage.getCredential(StringConstant.authToken);
    final userID = await appSecureStorage.getCredential(StringConstant.userID);

    final uri = Uri.parse(
      '${StringConstant.kBaseUrl}products?userID=$userID',
    );
    final response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == StringConstant.k200) {
      return homeResponseModelFromJson(response.body);
    } else {
      final errorMessage = json.decode(response.body);
      throw ServerFailure(errorMessage['message'], response.statusCode);
    }
  }
}
