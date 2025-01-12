import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/features/zibzo/data/datasources/auth/remote/user_remote_data_sources.dart';
import 'package:zibzo/features/zibzo/data/models/auth/user_model.dart';
import '../../../../../../fixture_reader/fixture_reader.dart';
import '../../../../../constants/signin_params.dart';
import '../../../../../constants/signup_params.dart';

class MockHttpClient extends Mock implements Client {}

class FakeUri extends Fake implements Uri {}

const errorMessage = 'Error message';

void main() {
  late MockHttpClient mockHttpClient;
  late UserRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    registerFallbackValue(FakeUri());
    dataSource = UserRemoteDataSourceImpl(client: mockHttpClient);
  });

  tearDown(() => {});

  group('signUp', () {
    test('should throw ServerFailure when the request fails', () async {
      // Arrange
      when(() => mockHttpClient
              .post(Uri.parse('${StringConstant.kBaseUrl}auth/signup/'), body: {
            'email': tSignUpParams.email,
            'userName': tSignUpParams.userName,
            'password': tSignUpParams.password,
          })).thenAnswer((_) async {
        await Future.delayed(Duration(seconds: 1));
        return Response(errorMessage, 400);
      });
      // Act & Assert
      expect(() => dataSource.signUp(tSignUpParams),
          throwsA(isA<ServerFailure>()));
    }, timeout: Timeout(Duration(minutes: 1)));
    test('should return UserModel when the request is successful', () async {
      // Arrange
      final fakeResponse = fixture('user/user_mocks.json');
      MockHttpClient mockHttpClient = MockHttpClient();

      when(() => mockHttpClient.post(
            Uri.parse('${StringConstant.kBaseUrl}auth/signup/'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => Response(fakeResponse, 201));
      // Act
      expect(dataSource.signUp(tSignUpParams), isNotNull);
    });
  });
  group("SignIn", () {
    test("should return UserModel when the request is successfull", () async {
      final fakeResponse = fixture('user/user_mocks.json');
      when(() => mockHttpClient
              .post(Uri.parse('${StringConstant.kBaseUrl}auth/login/'), body: {
            'email': tSignInParams.email,
            'password': tSignInParams.password,
          })).thenAnswer((_) async => Response(fakeResponse, 200));
      final result = await dataSource.signIn(tSignInParams);
      expect(result, isA<UserModel>());
    });

    test("should return ServerFailure when request is failure", () async {
      // Arrange
      final errorMessage = jsonEncode({"msg": "server error"});
      when(() => mockHttpClient.post(
            Uri.parse('${StringConstant.kBaseUrl}auth/login/'),
            body: {
              'email': tSignInParams.email,
              'password': tSignInParams.password,
            },
          )).thenAnswer(
        (_) async => Response(errorMessage, 400),
      );

      // Act & Assert
      expect(
        () => dataSource.signIn(tSignInParams),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
