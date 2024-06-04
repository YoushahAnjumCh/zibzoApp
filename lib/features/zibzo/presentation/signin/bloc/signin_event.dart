// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:zibzo_app/features/zibzo/domain/usecases/signin/signin_usecase.dart';

abstract class SignInEvent extends Equatable {}

class SignInButtonEvent extends SignInEvent {
  final SignInParams params;
  SignInButtonEvent({
    required this.params,
  });
  @override
  List<Object?> get props => [params];
}
