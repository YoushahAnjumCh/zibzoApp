import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';

class SharedPreferencesLoginUseCase {
  final AppLocalStorage authRepository;

  SharedPreferencesLoginUseCase(this.authRepository);

  Future<void> logIn(String username, String key) async {
    return await authRepository.saveToken(username);
  }
}

class SharedPreferencesLoginStatusUseCase {
  final AppLocalStorage authRepository;

  SharedPreferencesLoginStatusUseCase(this.authRepository);

  Future<bool> isLoggedIn() async {
    return await authRepository.isLoggedIn();
  }
}

// domain/usecases/logout_usecase.dart
class SharedPreferencesLogoutUseCase {
  final AppLocalStorage authRepository;

  SharedPreferencesLogoutUseCase(this.authRepository);

  Future<void> logOut(String key) async {
    return await authRepository.clearToken();
  }
}
