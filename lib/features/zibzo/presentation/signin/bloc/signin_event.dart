import 'package:zibzo/features/zibzo/domain/usecases/signin/signin_usecase.dart';

abstract class SignInEvent {}

class SignInButtonEvent extends SignInEvent {
  final SignInParams params;
  SignInButtonEvent({
    required this.params,
  });
}
