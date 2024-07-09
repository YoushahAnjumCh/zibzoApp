import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/core/network_info/network_info.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/auth/remote/user_remote_data_sources.dart';

import 'package:zibzo_app/features/zibzo/data/repositories/auth/user_repositories.dart';

import '../../../constants/signin_params.dart';
import '../../../constants/signup_params.dart';

class MockRemoteDataSource extends Mock implements UserRemoteDataSource {}

class MockNetWorkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockRemoteDataSource remoteDataSource;
  late NetworkInfo networkInfo;
  late UserRepositoryImpl userRepositoryImpl;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    networkInfo = MockNetWorkInfo();

    userRepositoryImpl = UserRepositoryImpl(
      networkInfo: networkInfo,
      remoteDataSource: remoteDataSource,
    );
  });
  group("SignUp section", () {
    group("device is online", () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //Arrange
        when(() => remoteDataSource.signUp(tSignUpParams))
            .thenAnswer((_) => Future.value(tUserModel));
        //Act
        await userRepositoryImpl.signUp(tSignUpParams);

        verify(() => remoteDataSource.signUp(tSignUpParams)).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      });
      test(
          'should return remote data when the call to remote data source is Failure',
          () async {
        //Arrange
        when(() => remoteDataSource.signUp(tSignUpParams))
            .thenThrow(const ServerFailure("", 500));
        //Act
        final result = await userRepositoryImpl.signUp(tSignUpParams);
        //Assert
        result.fold((left) => expect(left, isA<ServerFailure>()),
            (right) => fail("test failed"));
      });
    });

    group("device is offline", () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('should return Connection failure ', () async {
        //Act
        final result = await userRepositoryImpl.signUp(tSignUpParams);
        //Assert
        result.fold((left) => expect(left, isA<ConnectionFailure>()),
            (right) => fail("test failed"));
      });
    });
  });

  group("SignIn Section", () {
    group("is network is online", () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      });
      test("should return userModel when remotedatasouce called", () async {
        //Arrange
        when(() => remoteDataSource.signIn(tSignInParams))
            .thenAnswer((_) => Future.value(tUserModel));
        //Act
        final result = await userRepositoryImpl.signin(tSignInParams);
        result.fold((left) => fail("test failed"), (right) => Right(right));

        verify(() => remoteDataSource.signIn(tSignInParams)).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      });

      test("should return ServerFailure when remotedatasouce called", () async {
        //Arrange
        when(() => remoteDataSource.signIn(tSignInParams))
            .thenThrow(const ServerFailure("", 400));
        //Act
        final result = await userRepositoryImpl.signin(tSignInParams);
        result.fold(
          (left) => expect(left, isA<ServerFailure>()),
          (right) => fail("test failed"),
        );
      });
    });
  });
}
