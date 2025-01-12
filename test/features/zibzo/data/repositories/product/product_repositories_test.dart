import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/core/network_info/network_info.dart';
import 'package:zibzo/features/zibzo/data/datasources/products/product_remote_data_source.dart';
import 'package:zibzo/features/zibzo/data/repositories/product/product_repositories.dart';

import '../../../../constants/product_params.dart';

class MockProductDataSource extends Mock implements ProductDataSource {}

class MockNetWorkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockProductDataSource remoteDataSource;
  late NetworkInfo networkInfo;
  late ProductRepositoryImpl categoryProductRepositoryImpl;

  setUp(() {
    remoteDataSource = MockProductDataSource();
    networkInfo = MockNetWorkInfo();

    categoryProductRepositoryImpl = ProductRepositoryImpl(
      dataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  group("ProductRepositoryImpl", () {
    group("device is online", () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //Arrange
        when(() => remoteDataSource.getProducts())
            .thenAnswer((_) => Future.value(tProductResponse));
        //Act
        await categoryProductRepositoryImpl.getProducts();

        verify(() => remoteDataSource.getProducts()).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      });
      test(
          'should return remote data when the call to remote data source is Failure',
          () async {
        //Arrange
        when(() => remoteDataSource.getProducts())
            .thenThrow(const ServerFailure("", 500));
        //Act
        final result = await categoryProductRepositoryImpl.getProducts();
        //Assert
        result.fold((left) => expect(left, isA<ServerFailure>()),
            (right) => expect(right, isA<List>()));
      });

      test(
        'should return ServerFailure when the call to remote data source throws SocketException',
        () async {
          // Arrange
          when(() => remoteDataSource.getProducts())
              .thenThrow(const SocketException("No Internet"));
          // Act
          final result = await categoryProductRepositoryImpl.getProducts();

          // Assert
          result.fold(
            (left) {
              // Ensure that the returned failure is of type ServerFailure, and check error message
              expect(left, isA<ServerFailure>());
              expect((left as ServerFailure).errorMessage, "No Internet");
              expect((left).errorCode, 500);
            },
            (right) => fail("test failed"),
          );
        },
      );
    });
    group("device is offline", () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('should return Connection failure ', () async {
        //Act
        final result = await categoryProductRepositoryImpl.getProducts();

        //Assert
        result.fold((left) => expect(left, isA<ConnectionFailure>()),
            (right) => fail("test failed"));
      });
    });
  });
}
