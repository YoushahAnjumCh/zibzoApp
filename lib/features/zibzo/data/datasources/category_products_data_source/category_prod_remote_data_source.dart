import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo_app/core/service/service_locator.dart';
import 'package:zibzo_app/features/zibzo/data/models/products/product_model.dart';

abstract class CategoryProductDataSource {
  Future<List<ProductModel>> getCategoryProducts(String params);
}

class CategoryProductRemoteDataSourceImpl implements CategoryProductDataSource {
  final http.Client client;
  CategoryProductRemoteDataSourceImpl({required this.client});

  final AppLocalStorage appSecureStorage = sl<AppLocalStorage>();

  @override
  Future<List<ProductModel>> getCategoryProducts(String params) async {
    final token = await appSecureStorage.getToken(StringConstant.authToken);
    final uri = Uri.parse(
      '${StringConstant.kBaseUrl}products/category/$params',
    );
    final response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      final errorMessage = json.decode(response.body);
      throw ServerFailure(errorMessage['message'], response.statusCode);
    }
  }
}
