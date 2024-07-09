import 'package:json_annotation/json_annotation.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/signup/user.dart';

part 'user_model.g.dart';

const kidKey = '_id';
const kfirstNameKey = 'firstName';
const klastNameKey = 'lastName';
const kemailKey = 'email';
const ktokenKey = 'token';

@JsonSerializable()
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

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
