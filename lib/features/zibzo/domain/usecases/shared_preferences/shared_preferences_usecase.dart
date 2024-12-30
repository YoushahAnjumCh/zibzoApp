import 'package:zibzo/core/secure_storage/app_secure_storage.dart';

class SharedPreferencesLoginUseCase {
  final AppLocalStorage authRepository;

  SharedPreferencesLoginUseCase(this.authRepository);

  Future<void> logIn(String username, String key) async {
    return await authRepository.saveCredential(username);
  }
}

class SharedPreferencesLoginStatusUseCase {
  final AppLocalStorage authRepository;

  SharedPreferencesLoginStatusUseCase(this.authRepository);

  Future<bool> isLoggedIn() async {
    return await authRepository.isLoggedIn();
  }
}

class SharedPreferencesLogoutUseCase {
  final AppLocalStorage authRepository;

  SharedPreferencesLogoutUseCase(this.authRepository);

  Future<void> logOut(String key) async {
    return await authRepository.clearCredential();
  }
}
