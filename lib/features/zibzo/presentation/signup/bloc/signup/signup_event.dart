part of 'signup_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class SignupUser extends UserEvent {
  final SignUpParams params;
  const SignupUser(this.params);
}

class TogglePasswordVisibility extends UserEvent {
  @override
  List<Object> get props => [];
}
