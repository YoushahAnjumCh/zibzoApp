import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/shared_preferences/shared_preferences_repository.dart';

class SharedPreferencesRepositoryImpl implements SharedPreferencesRepository {
  final AppLocalStorage localDataSource;

  SharedPreferencesRepositoryImpl(this.localDataSource);

  @override
  Future<void> login(String username) async {
    await localDataSource.saveToken(username);
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.isLoggedIn();
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearToken();
  }
}
