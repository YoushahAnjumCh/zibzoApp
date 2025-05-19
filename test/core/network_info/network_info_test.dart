import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo/core/network_info/network_info.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockConnectionChecker;

  setUp(() {
    mockConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to InternetConnectionChecker.hasConnection',
        () async {
      // Arrange
      when(() => mockConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);

      // Act
      final result = await networkInfo.isConnected;

      // Assert
      verify(() => mockConnectionChecker.hasConnection).called(1);
      expect(result, true);
    });

    test(
        'should return false when InternetConnectionChecker.hasConnection is false',
        () async {
      // Arrange
      when(() => mockConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);

      // Act
      final result = await networkInfo.isConnected;

      // Assert
      verify(() => mockConnectionChecker.hasConnection).called(1);
      expect(result, false);
    });
  });
}
