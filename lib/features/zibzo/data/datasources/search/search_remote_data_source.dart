import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/data/models/products/product_model.dart';
import 'package:zibzo/features/zibzo/domain/usecases/search/search_usecase.dart';

abstract class SearchDataSource {
  Future<List<ProductModel>> searchProduct(SearchUseCaseParams params);
}

class SearchRemoteDataSourceImpl implements SearchDataSource {
  final http.Client client;
  SearchRemoteDataSourceImpl({required this.client});
  final AppLocalStorage appSecureStorage = sl<AppLocalStorage>();

  @override
  Future<List<ProductModel>> searchProduct(SearchUseCaseParams params) async {
    final token =
        await appSecureStorage.getCredential(StringConstant.authToken);

    final uri = Uri.parse(
      '${StringConstant.kBaseUrl}products/search?q=${params.query}&limit=${params.limit}&offset=${params.offset}',
    );
    final response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == StringConstant.k200) {
      final List<dynamic> jsonResponse = json.decode(response.body);

      return jsonResponse.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      final errorMessage = json.decode(response.body);
      throw ServerFailure(errorMessage['message'], response.statusCode);
    }
  }
}
