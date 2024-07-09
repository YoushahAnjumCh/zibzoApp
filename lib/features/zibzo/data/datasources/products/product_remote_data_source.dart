import 'dart:convert';

import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo_app/core/service/service_locator.dart';
import 'package:zibzo_app/features/zibzo/data/models/products/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:zibzo_app/features/zibzo/domain/usecases/home_page/product_use_case.dart';

abstract class ProductDataSource {
  Future<List<ProductModel>> getProducts(ProductsParams params);
  Future<ProductModel> getProductById(int id);
}

class ProductRemoteDataSourceImpl implements ProductDataSource {
  final http.Client client;
  ProductRemoteDataSourceImpl({required this.client});

  final AppLocalStorage appSecureStorage =
      sl<AppLocalStorage>(instanceName: 'secureStorage');

  @override
  Future<List<ProductModel>> getProducts(params) async {
    final token = await appSecureStorage.readFromStorage('token');
    final uri = Uri.parse(
      '${StringConstant.kBaseUrl}products?limit=${params.limit}&offset=${params.offset}',
    );
    final response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      List<dynamic> productList = json.decode(response.body);
      return productList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      final errorMessage = json.decode(response.body);
      throw ServerFailure(errorMessage['message'], response.statusCode);
    }
  }

  @override
  Future<ProductModel> getProductById(id) async {
    final token = await appSecureStorage.readFromStorage('token');
    final uri = Uri.parse(
      '${StringConstant.kBaseUrl}products/$id',
    );
    final response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    } else {
      final errorMessage = json.decode(response.body);
      throw ServerFailure(errorMessage['message'], response.statusCode);
    }
  }
}
