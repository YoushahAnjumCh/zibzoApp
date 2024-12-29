import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/core/network_info/network_info.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/cart/cart_remote_data_source.dart';
import 'package:zibzo_app/features/zibzo/data/models/cart/cart_count_model.dart';
import 'package:zibzo_app/features/zibzo/data/models/cart/cart_response_model.dart';
import 'package:zibzo_app/features/zibzo/data/repositories/cart/cart_repository_impl.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/cart/add_cart_usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/cart/delete_cart_usecase.dart';

class MockCartDataSource extends Mock implements CartDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockCartDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late CartRepositoryImpl cartRepositoryImpl;

  setUp(() {
    remoteDataSource = MockCartDataSource();
    networkInfo = MockNetworkInfo();

    cartRepositoryImpl = CartRepositoryImpl(
      cartDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  group("CartRepositoryImpl", () {
    group("device is online addCart", () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return CartResponseEntity when the call to remote data source is successful',
          () async {
        // Arrange
        final cartCount = CartCountModel(cartCount: 1);
        final params = AddCartParams(productId: "products");
        when(() => remoteDataSource.addCart(params))
            .thenAnswer((_) async => Future.value(cartCount));

        // Act
        final result = await cartRepositoryImpl.addCart(params);

        // Assert
        result.fold(
          (left) => fail("Expected Right, but got Left: $left"),
          (right) {
            expect(right, isA<CartCountModel>());
          },
        );
      });

      test(
          'should return ServerFailure when the call to remote data source throws ServerFailure',
          () async {
        final params = AddCartParams(productId: "products");

        // Arrange
        when(() => remoteDataSource.addCart(params))
            .thenThrow(const ServerFailure("Server error", 500));

        // Act
        final result = await cartRepositoryImpl.addCart(params);

        // Assert
        result.fold(
          (left) {
            expect(left, isA<ServerFailure>());
            expect((left as ServerFailure).errorMessage, "Server error");
            expect(left.errorCode, 500);
          },
          (right) => fail("Expected Left, but got Right: $right"),
        );
      });

      test(
          'should return ServerFailure when the call to remote data source throws SocketException',
          () async {
        final params = AddCartParams(productId: "products");

        // Arrange
        when(() => remoteDataSource.addCart(params))
            .thenThrow(const SocketException("No Internet"));

        // Act
        final result = await cartRepositoryImpl.addCart(params);

        // Assert
        result.fold(
          (left) {
            expect(left, isA<ServerFailure>());
            expect((left as ServerFailure).errorMessage, "No Internet");
            expect(left.errorCode, 500);
          },
          (right) => fail("Expected Left, but got Right: $right"),
        );
      });
    });

    group("device is online getCart", () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return CartResponseEntity when the call to remote data source is successful',
          () async {
        // Arrange
        final response = CartResponseModel(products: [], cartProductCount: 1);

        when(() => remoteDataSource.getCart())
            .thenAnswer((_) async => Future.value(response));

        // Act
        final result = await cartRepositoryImpl.getCart();

        // Assert
        result.fold(
          (left) => fail("Expected Right, but got Left: $left"),
          (right) {
            expect(right, isA<CartResponseModel>());
          },
        );
      });

      test(
          'should return ServerFailure when the call to remote data source throws ServerFailure',
          () async {
        // Arrange
        when(() => remoteDataSource.getCart())
            .thenThrow(const ServerFailure("Server error", 500));

        // Act
        final result = await cartRepositoryImpl.getCart();

        // Assert
        result.fold(
          (left) {
            expect(left, isA<ServerFailure>());
            expect((left as ServerFailure).errorMessage, "Server error");
            expect(left.errorCode, 500);
          },
          (right) => fail("Expected Left, but got Right: $right"),
        );
      });

      test(
          'should return ServerFailure when the call to remote data source throws SocketException',
          () async {
        // Arrange
        when(() => remoteDataSource.getCart())
            .thenThrow(const SocketException("No Internet"));

        // Act
        final result = await cartRepositoryImpl.getCart();

        // Assert
        result.fold(
          (left) {
            expect(left, isA<ServerFailure>());
            expect((left as ServerFailure).errorMessage, "No Internet");
            expect(left.errorCode, 500);
          },
          (right) => fail("Expected Left, but got Right: $right"),
        );
      });
    });

    group("device is online removeCart", () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return CartResponseEntity when the call to remote data source is successful',
          () async {
        // Arrange
        final response = CartResponseModel(products: [], cartProductCount: 1);
        final params = DeleteCartParams(productID: "productID");
        when(() => remoteDataSource.removeCart(params))
            .thenAnswer((_) async => Future.value(response));

        // Act
        final result = await cartRepositoryImpl.removeCart(params);

        // Assert
        result.fold(
          (left) => fail("Expected Right, but got Left: $left"),
          (right) {
            expect(right, isA<CartResponseModel>());
          },
        );
      });

      test(
          'should return ServerFailure when the call to remote data source throws ServerFailure',
          () async {
        final params = DeleteCartParams(productID: "productID");

        // Arrange
        when(() => remoteDataSource.removeCart(params))
            .thenThrow(const ServerFailure("Server error", 500));

        // Act
        final result = await cartRepositoryImpl.removeCart(params);

        // Assert
        result.fold(
          (left) {
            expect(left, isA<ServerFailure>());
            expect((left as ServerFailure).errorMessage, "Server error");
            expect(left.errorCode, 500);
          },
          (right) => fail("Expected Left, but got Right: $right"),
        );
      });

      test(
          'should return ServerFailure when the call to remote data source throws SocketException',
          () async {
        final params = DeleteCartParams(productID: "productID");

        // Arrange
        when(() => remoteDataSource.removeCart(params))
            .thenThrow(const SocketException("No Internet"));

        // Act
        final result = await cartRepositoryImpl.removeCart(params);

        // Assert
        result.fold(
          (left) {
            expect(left, isA<ServerFailure>());
            expect((left as ServerFailure).errorMessage, "No Internet");
            expect(left.errorCode, 500);
          },
          (right) => fail("Expected Left, but got Right: $right"),
        );
      });
    });

    group("device is offline ", () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return ConnectionFailure when trying to add cart item',
          () async {
        // Act
        final result =
            await cartRepositoryImpl.addCart(AddCartParams(productId: "123"));

        // Assert
        result.fold(
          (left) => expect(left, isA<ConnectionFailure>()),
          (right) => fail("Expected Left, but got Right: $right"),
        );
      });

      test('should return ConnectionFailure when trying to get cart item',
          () async {
        // Act
        final result = await cartRepositoryImpl.getCart();

        // Assert
        result.fold(
          (left) => expect(left, isA<ConnectionFailure>()),
          (right) => fail("Expected Left, but got Right: $right"),
        );
      });
      test('should return ConnectionFailure when trying to remove cart item',
          () async {
        final params = DeleteCartParams(productID: "product");
        // Act
        final result = await cartRepositoryImpl.removeCart(params);

        // Assert
        result.fold(
          (left) => expect(left, isA<ConnectionFailure>()),
          (right) => fail("Expected Left, but got Right: $right"),
        );
      });
    });
  });
}
