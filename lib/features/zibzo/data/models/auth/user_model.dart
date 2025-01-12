import 'package:json_annotation/json_annotation.dart';
import 'package:zibzo/features/zibzo/domain/entities/signup/user.dart';

part 'user_model.g.dart';

const kidKey = '_id';
const kfirstNameKey = 'firstName';
const kuserNameKey = 'userName';
const kemailKey = 'email';
const ktokenKey = 'token';

@JsonSerializable()
class UserModel extends User {
  const UserModel(
      {required String id,
      required String userName,
      required String email,
      String? token,
      String? image})
      : super(
            email: email,
            id: id,
            userName: userName,
            token: token,
            image: image);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
