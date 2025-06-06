import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/data/datasources/products/product_remote_data_source.dart';
import 'package:zibzo/features/zibzo/data/models/products/product_response_model.dart';

import '../../../../../fixture_reader/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockAppLocalStorage extends Mock implements AppLocalStorage {}

void main() {
  late MockHttpClient mockHttpClient;
  late ProductRemoteDataSourceImpl dataSource;
  late MockAppLocalStorage mockAppLocalStorage;
  setUp(() {
    mockHttpClient = MockHttpClient();
    mockAppLocalStorage = MockAppLocalStorage();
    sl.registerLazySingleton<AppLocalStorage>(() => mockAppLocalStorage);

    dataSource = ProductRemoteDataSourceImpl(client: mockHttpClient);
  });
  tearDown(() {
    sl.reset();
  });
  group("get all products and categories", () {
    test("should return Product Response Model when request is successfull ",
        () async {
      // Mock token retrieval
      when(() => mockAppLocalStorage.getCredential(StringConstant.authToken))
          .thenAnswer((_) async => 'fake_token');
      when(() => mockAppLocalStorage.getCredential(StringConstant.userID))
          .thenAnswer((_) async => 'userID');

      //Arrange
      final fakeResponse = fixture('products/home_page_products.json');
      when(() => mockHttpClient.get(
            Uri.parse('${StringConstant.kBaseUrl}products?userID=userID'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer fake_token',
            },
          )).thenAnswer((_) async => http.Response(fakeResponse, 200));

      //Act
      final result = await dataSource.getProducts();

      // Assert
      expect(result, isA<ProductResponseModel>());
    });
    test("should return ServerFailure when request is failure", () async {
      // Mock token retrieval
      final errorMessage = jsonEncode({"message": "server error"});

      when(() => mockAppLocalStorage.getCredential(StringConstant.authToken))
          .thenAnswer((_) async => 'fake_token');
      when(() => mockAppLocalStorage.getCredential(StringConstant.userID))
          .thenAnswer((_) async => 'userID');

      // Arrange
      when(() => mockHttpClient.get(
            Uri.parse('${StringConstant.kBaseUrl}products?userID=userID'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer fake_token',
            },
          )).thenAnswer(
        (_) async => http.Response(errorMessage, 400),
      );

      // Act & Assert
      expect(
        () => dataSource.getProducts(),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
