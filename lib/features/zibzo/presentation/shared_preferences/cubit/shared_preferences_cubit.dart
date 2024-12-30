import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zibzo/features/zibzo/domain/usecases/shared_preferences/shared_preferences_usecase.dart';
import 'package:zibzo/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_state.dart';

class SharedPreferencesCubit extends Cubit<AuthState> {
  final SharedPreferencesLoginUseCase sharedPreferencesLoginUseCase;
  final SharedPreferencesLoginStatusUseCase sharedPreferencesLoginStatusUseCase;
  final SharedPreferencesLogoutUseCase sharedPreferencesLogoutUseCase;

  SharedPreferencesCubit(this.sharedPreferencesLoginStatusUseCase,
      this.sharedPreferencesLoginUseCase, this.sharedPreferencesLogoutUseCase)
      : super(Unauthenticated());

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await sharedPreferencesLoginStatusUseCase.isLoggedIn();
    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> login(String username, String key) async {
    await sharedPreferencesLoginUseCase.logIn(key, username);
    emit(Authenticated());
  }

  Future<void> logout(String key) async {
    await sharedPreferencesLogoutUseCase.logOut(key);
    emit(Unauthenticated());
  }
}
