import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserLogged extends UserState {
  UserLogged();
  @override
  List<Object> get props => [];
}

class UserLoggedFail extends UserState {
  final String failure;
  UserLoggedFail(this.failure);
  @override
  List<Object> get props => [failure];
}

class UserLoggedOut extends UserState {
  @override
  List<Object> get props => [];
}
