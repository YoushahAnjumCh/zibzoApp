import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String userName;
  final String? image;
  final String email;
  final String? token;
  const User({
    required this.id,
    required this.userName,
    this.image,
    this.token,
    required this.email,
  });

  @override
  List<Object> get props => [
        id,
        userName,
        email,
      ];
}
