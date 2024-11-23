part of 'signup_bloc.dart';

abstract class UserEvent {
  const UserEvent();
}

class SignupUser extends UserEvent {
  final SignUpParams params;
  const SignupUser(this.params);
}

class TogglePasswordVisibility extends UserEvent {}
