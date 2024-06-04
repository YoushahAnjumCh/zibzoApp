import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/auth/remote/user_remote_data_sources.dart';
import 'package:zibzo_app/features/zibzo/data/models/auth/user_model.dart';

import '../../../../../../fixture_reader/fixture_reader.dart';
import '../../../../../constants/signin_params/signin_params.dart';
import '../../../../../constants/signup_params/signup_params.dart';

// Create a mock for http.Client
class MockHttpClient extends Mock implements http.Client {}

const errorMessage = 'Error message';

void main() {
  late MockHttpClient mockHttpClient;
  late UserRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = UserRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('signUp', () {
    test('should return UserModel when the request is successful', () async {
      // Arrange

      final fakeResponse = fixture('user/user_mocks.json');
      when(() => mockHttpClient
              .post(Uri.parse('${StringConstant.kBaseUrl}auth/signup/'), body: {
            'firstName': tSignUpParams.firstName,
            'lastName': tSignUpParams.lastName,
            'email': tSignUpParams.email,
            'password': tSignUpParams.password,
          })).thenAnswer((_) async => http.Response(fakeResponse, 201));

      // Act
      final result = await dataSource.signUp(tSignUpParams);

      // Assert
      expect(result, isA<UserModel>());
    });

    test('should throw ServerFailure when the request fails', () async {
      // Arrange

      when(() => mockHttpClient
              .post(Uri.parse('${StringConstant.kBaseUrl}auth/signup/'), body: {
            'firstName': tSignUpParams.firstName,
            'lastName': tSignUpParams.lastName,
            'email': tSignUpParams.email,
            'password': tSignUpParams.password,
          })).thenAnswer((_) async => http.Response(errorMessage, 400));

      // Act & Assert
      expect(() => dataSource.signUp(tSignUpParams),
          throwsA(isA<ServerFailure>()));
    });
  });
  group("SignIn", () {
    test("should return UserModel when the request is successfull", () async {
      final fakeResponse = fixture('user/user_mocks.json');
      when(() => mockHttpClient
              .post(Uri.parse('${StringConstant.kBaseUrl}auth/login/'), body: {
            'email': tSignInParams.email,
            'password': tSignInParams.password,
          })).thenAnswer((_) async => http.Response(fakeResponse, 200));
      final result = await dataSource.signIn(tSignInParams);
      expect(result, isA<UserModel>());
    });

    test("should return ServerFailure when request is failure", () async {
      when(() => mockHttpClient
              .post(Uri.parse('${StringConstant.kBaseUrl}auth/login/'), body: {
            'email': tSignInParams.email,
            'password': tSignInParams.password,
          })).thenAnswer((_) async => http.Response(errorMessage, 400));
      expect(() => dataSource.signIn(tSignInParams),
          throwsA(isA<ServerFailure>()));
    });
  });
}
