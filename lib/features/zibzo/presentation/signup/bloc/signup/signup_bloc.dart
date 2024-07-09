import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/bloc/signup/signup_state.dart';

part 'signup_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SignUpUseCase _useCase;
  UserBloc(this._useCase) : super(UserInitial()) {
    on<SignupUser>(_onSignUp);
  }

  FutureOr<void> _onSignUp(SignupUser event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final result = await _useCase(event.params);
      result.fold(
        (failure) {
          emit(UserLoggedFail(failure.errorMessage.toString()));
        },
        (user) => emit(UserLogged()),
      );
    } on ServerFailure catch (e) {
      emit(UserLoggedFail(e.errorMessage.toString()));
    }
  }
}
