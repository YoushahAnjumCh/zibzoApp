import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signin/signin_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_event.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase useCase;
  SignInBloc(this.useCase) : super(SignInInitial()) {
    on<SignInButtonEvent>(_signIn);
  }

  Future<void> _signIn(
      SignInButtonEvent event, Emitter<SignInState> emit) async {
    try {
      emit(SignInLoading());
      final result = await useCase.call(event.params);
      result.fold((left) {
        emit(SignInFail(message: left.errorMessage.toString()));
      }, (right) {
        emit(SignInSuccess(user: result.right));
      });
    } on ServerFailure catch (e) {
      emit(SignInFail(message: e.errorMessage.toString()));
    }
  }
}
