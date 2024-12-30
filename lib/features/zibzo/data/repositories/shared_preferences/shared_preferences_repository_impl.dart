import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/features/zibzo/domain/repositories/shared_preferences/shared_preferences_repository.dart';

class SharedPreferencesRepositoryImpl implements SharedPreferencesRepository {
  final AppLocalStorage localDataSource;

  SharedPreferencesRepositoryImpl(this.localDataSource);

  @override
  Future<void> login(String username) async {
    await localDataSource.saveCredential(username);
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.isLoggedIn();
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearCredential();
  }
}
