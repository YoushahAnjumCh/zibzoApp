import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signin/signin_usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';
import '../../../models/auth/user_model.dart';

const _statusCode201 = 201;
const _statusCode200 = 200;

abstract class UserRemoteDataSource {
  Future<UserModel> signUp(SignUpParams params);
  Future<UserModel> signIn(SignInParams params);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  const UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> signUp(SignUpParams params) async {
    final response = await client
        .post(Uri.parse('${StringConstant.kBaseUrl}auth/signup/'), body: {
      "firstName": params.firstName,
      "lastName": params.lastName,
      "email": params.email,
      "password": params.password
    });
    if (response.statusCode == _statusCode201) {
      return userModelFromJson(response.body);
    } else {
      throw ServerFailure(response.body, response.statusCode);
    }
  }

  @override
  Future<UserModel> signIn(SignInParams params) async {
    final response = await client.post(
        Uri.parse('${StringConstant.kBaseUrl}auth/login/'),
        body: {"email": params.email, "password": params.password});
    if (response.statusCode == _statusCode200) {
      return userModelFromJson(response.body);
    } else {
      final errorMessage = jsonDecode(response.body);

      throw ServerFailure(errorMessage['msg'], response.statusCode);
    }
  }
}
