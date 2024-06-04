import 'package:equatable/equatable.dart';

import 'package:zibzo_app/features/zibzo/domain/entities/signup/user.dart';

abstract class SignInState extends Equatable {}

class SignInInitial extends SignInState {
  @override
  List<Object> get props => [];
}

class SignInLoading extends SignInState {
  @override
  List<Object> get props => [];
}

class SignInSuccess extends SignInState {
  final User user;
  SignInSuccess({required this.user});
  @override
  List<Object> get props => [user];
}

class SignInFail extends SignInState {
  final String message;
  SignInFail({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
