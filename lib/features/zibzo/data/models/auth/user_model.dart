import 'dart:convert';

import 'package:zibzo_app/features/zibzo/domain/entities/signup/user.dart';

UserModel userModelFromJson(String str) => UserModel.fromMap(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toMap());

const kidKey = '_id';
const kfirstNameKey = 'firstName';
const klastNameKey = 'lastName';
const kemailKey = 'email';
const ktokenKey = 'token';

class UserModel extends User {
  const UserModel({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    String? token,
  }) : super(
            email: email,
            firstName: firstName,
            id: id,
            lastName: lastName,
            token: token);

  Map<String, dynamic> toMap() {
    return {
      kidKey: id,
      kfirstNameKey: firstName,
      klastNameKey: lastName,
      kemailKey: email,
      ktokenKey: token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        email: map['email'],
        firstName: map['firstName'],
        id: map['id'],
        lastName: map['lastName'],
        token: map['token']);
  }
}
