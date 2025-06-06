import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/features/zibzo/domain/usecases/signin/signin_usecase.dart';
import 'package:zibzo/features/zibzo/domain/usecases/signup/signup_usecase.dart';
import '../../../models/auth/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> signUp(SignUpParams params);
  Future<UserModel> signIn(SignInParams params);
}

class UserRemoteDataSourceImpl implements UserDataSource {
  final http.Client client;
  const UserRemoteDataSourceImpl({required this.client});
  @override
  Future<UserModel> signUp(SignUpParams params) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${StringConstant.kBaseUrl}auth/signup/'),
    );

    request.fields['userName'] = params.userName;
    request.fields['email'] = params.email;
    request.fields['password'] = params.password;

    if (params.selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'userImage',
        params.selectedImage!.path,
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == StringConstant.k201) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      final errorMessage = jsonDecode(response.body);
      throw ServerFailure(errorMessage['msg'], response.statusCode);
    }
  }

  @override
  Future<UserModel> signIn(SignInParams params) async {
    final response = await client.post(
        Uri.parse('${StringConstant.kBaseUrl}auth/login/'),
        body: {"email": params.email, "password": params.password});
    if (response.statusCode == StringConstant.k200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      final errorMessage = jsonDecode(response.body);
      throw ServerFailure(errorMessage['msg'], response.statusCode);
    }
  }
}
