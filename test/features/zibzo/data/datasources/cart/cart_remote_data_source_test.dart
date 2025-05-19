import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/data/datasources/cart/cart_remote_data_source.dart';
import 'package:zibzo/features/zibzo/data/models/cart/cart_count_model.dart';
import 'package:zibzo/features/zibzo/data/models/cart/cart_response_model.dart';
import 'package:zibzo/features/zibzo/domain/usecases/cart/add_cart_usecase.dart';
import 'package:zibzo/features/zibzo/domain/usecases/cart/delete_cart_usecase.dart';

import '../../../../../fixture_reader/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockAppLocalStorage extends Mock implements AppLocalStorage {}

void main() {
  late MockHttpClient mockHttpClient;
  late CartRemoteDataSourceImpl dataSource;
  late MockAppLocalStorage mockAppLocalStorage;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockAppLocalStorage = MockAppLocalStorage();
    sl.registerLazySingleton<AppLocalStorage>(() => mockAppLocalStorage);

    dataSource = CartRemoteDataSourceImpl(client: mockHttpClient);
  });

  tearDown(() {
    sl.reset();
  });

  group("CartRemoteDataSource", () {
    test("should return CartCountModel when addCart request is successful",
        () async {
      // Mock token and userID retrieval
      when(() => mockAppLocalStorage.getCredential(StringConstant.authToken))
          .thenAnswer((_) async => 'fake_token');
      when(() => mockAppLocalStorage.getCredential(StringConstant.userID))
          .thenAnswer((_) async => 'userID');

      // Arrange
      final fakeResponse = fixture('cart/cart_response.json');
      when(() => mockHttpClient.post(
            Uri.parse('${StringConstant.kBaseUrl}cart'),
            body: {
              'userID': 'userID',
              'productID': 'productId',
            },
            headers: {'Authorization': 'Bearer fake_token'},
          )).thenAnswer((_) async => http.Response(fakeResponse, 201));

      final params = AddCartParams(productId: 'productId');

      // Act
      final result = await dataSource.addCart(params);

      // Assert
      expect(result, isA<CartCountModel>());
    });

    test("should return ServerFailure when addCart request fails", () async {
      // Mock token and userID retrieval
      final errorMessage = jsonEncode({"message": "server error"});

      when(() => mockAppLocalStorage.getCredential(StringConstant.authToken))
          .thenAnswer((_) async => 'fake_token');
      when(() => mockAppLocalStorage.getCredential(StringConstant.userID))
          .thenAnswer((_) async => 'userID');

      // Arrange
      when(() => mockHttpClient.post(
            Uri.parse('${StringConstant.kBaseUrl}cart'),
            body: {
              'userID': 'userID',
              'productID': 'productId',
            },
            headers: {'Authorization': 'Bearer fake_token'},
          )).thenAnswer(
        (_) async => http.Response(errorMessage, 400),
      );

      final params = AddCartParams(productId: 'productId');

      // Act & Assert
      expect(
        () => dataSource.addCart(params),
        throwsA(isA<ServerFailure>()),
      );
    });

    test("should return CartResponseModel when getCart request is successful",
        () async {
      // Mock token and userID retrieval
      when(() => mockAppLocalStorage.getCredential(StringConstant.authToken))
          .thenAnswer((_) async => 'fake_token');
      when(() => mockAppLocalStorage.getCredential(StringConstant.userID))
          .thenAnswer((_) async => 'userID');

      // Arrange
      final fakeResponse = fixture('cart/cart_response.json');
      when(() => mockHttpClient.get(
            Uri.parse('${StringConstant.kBaseUrl}cart?userID=userID'),
            headers: {'Authorization': 'Bearer fake_token'},
          )).thenAnswer((_) async => http.Response(fakeResponse, 200));

      // Act
      final result = await dataSource.getCart();

      // Assert
      expect(result, isA<CartResponseModel>());
    });

    test("should return ServerFailure when getCart request fails", () async {
      // Mock token and userID retrieval
      final errorMessage = jsonEncode({"message": "server error"});

      when(() => mockAppLocalStorage.getCredential(StringConstant.authToken))
          .thenAnswer((_) async => 'fake_token');
      when(() => mockAppLocalStorage.getCredential(StringConstant.userID))
          .thenAnswer((_) async => 'userID');

      // Arrange
      when(() => mockHttpClient.get(
            Uri.parse('${StringConstant.kBaseUrl}cart?userID=userID'),
            headers: {'Authorization': 'Bearer fake_token'},
          )).thenAnswer(
        (_) async => http.Response(errorMessage, 400),
      );

      // Act & Assert
      expect(
        () => dataSource.getCart(),
        throwsA(isA<ServerFailure>()),
      );
    });

    test(
        "should return CartResponseModel when removeCart request is successful",
        () async {
      // Mock token and userID retrieval
      when(() => mockAppLocalStorage.getCredential(StringConstant.authToken))
          .thenAnswer((_) async => 'fake_token');
      when(() => mockAppLocalStorage.getCredential(StringConstant.userID))
          .thenAnswer((_) async => 'userID');

      // Arrange
      final fakeResponse = fixture('cart/cart_response.json');
      when(() => mockHttpClient.delete(
            Uri.parse('${StringConstant.kBaseUrl}cart'),
            body: {
              'userID': 'userID',
              'productID': 'productId',
            },
            headers: {'Authorization': 'Bearer fake_token'},
          )).thenAnswer((_) async => http.Response(fakeResponse, 200));

      final params = DeleteCartParams(productID: 'productId');

      // Act
      final result = await dataSource.removeCart(params);

      // Assert
      expect(result, isA<CartResponseModel>());
    });

    test("should return ServerFailure when removeCart request fails", () async {
      final errorMessage = jsonEncode({"message": "server error"});

      when(() => mockAppLocalStorage.getCredential(StringConstant.authToken))
          .thenAnswer((_) async => 'fake_token');
      when(() => mockAppLocalStorage.getCredential(StringConstant.userID))
          .thenAnswer((_) async => 'userID');

      // Arrange
      when(() => mockHttpClient.delete(
            Uri.parse('${StringConstant.kBaseUrl}cart'),
            body: {
              'userID': 'userID',
              'productID': 'productId',
            },
            headers: {'Authorization': 'Bearer fake_token'},
          )).thenAnswer(
        (_) async => http.Response(errorMessage, 400),
      );

      final params = DeleteCartParams(productID: 'productId');

      // Act & Assert
      expect(
        () => dataSource.removeCart(params),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
