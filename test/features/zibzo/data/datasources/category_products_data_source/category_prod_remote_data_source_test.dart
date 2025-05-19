import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/data/datasources/category_products_data_source/category_prod_remote_data_source.dart';
import 'package:zibzo/features/zibzo/data/models/products/product_model.dart';

import '../../../../../fixture_reader/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockAppLocalStorage extends Mock implements AppLocalStorage {}

void main() {
  late MockHttpClient mockHttpClient;
  late CategoryProductRemoteDataSourceImpl dataSource;
  late MockAppLocalStorage mockAppLocalStorage;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockAppLocalStorage = MockAppLocalStorage();
    sl.registerLazySingleton<AppLocalStorage>(() => mockAppLocalStorage);

    dataSource = CategoryProductRemoteDataSourceImpl(client: mockHttpClient);
  });

  tearDown(() {
    reset(mockHttpClient);
    sl.reset();
  });

  group("get Products By Category", () {
    test("should return ProductsModel when request is successfull", () async {
      // Mock token retrieval
      when(() => mockAppLocalStorage.getCredential(StringConstant.authToken))
          .thenAnswer((_) async => 'fake_token');

      //Arrange
      final fakeResponse =
          fixture('productsByCategory/get_products_by_category.json');
      when(() => mockHttpClient.get(
            Uri.parse('${StringConstant.kBaseUrl}products/category/Men'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer fake_token',
            },
          )).thenAnswer((_) async => http.Response(fakeResponse, 200));

      //Act
      final result = await dataSource.getCategoryProducts("Men");

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test("should return ServerFailure when request is failure", () async {
      // Mock token retrieval
      final errorMessage = jsonEncode({"message": "server error"});

      when(() => mockAppLocalStorage.getCredential(StringConstant.authToken))
          .thenAnswer((_) async => 'fake_token');

      // Arrange
      when(() => mockHttpClient.get(
            Uri.parse('${StringConstant.kBaseUrl}products/category/Men'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer fake_token',
            },
          )).thenAnswer(
        (_) async => http.Response(errorMessage, 400),
      );

      // Act & Assert
      expect(
        () => dataSource.getCategoryProducts("Men"),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
