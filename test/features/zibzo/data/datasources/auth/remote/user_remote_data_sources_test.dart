import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/core/constant/assets_path.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/auth/remote/user_remote_data_sources.dart';
import 'package:zibzo_app/features/zibzo/data/models/auth/user_model.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';
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

  String generateRandomEmail() {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();

    // Generate a random string for the username part
    String username = List.generate(
        10, (index) => characters[random.nextInt(characters.length)]).join();

    // Append "@gmail.com" to the username
    return '$username@gmail.com';
  }

  final tSignUpParam = SignUpParams(
      email: generateRandomEmail(),
      userName: "userName",
      password: "password",
      selectedImage: File(AssetsPath.appLogo));

  group('signUp', () {
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
      expect(dataSource.signUp(tSignUpParam), isNotNull);
    });

    test('should throw ServerFailure when the request fails', () async {
      // Arrange

      when(() => mockHttpClient
              .post(Uri.parse('${StringConstant.kBaseUrl}auth/signup/'), body: {
            'email': tSignUpParams.email,
            'userName': tSignUpParams.userName,
            'password': tSignUpParams.password,
          })).thenAnswer((_) async => Response(errorMessage, 400));

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
