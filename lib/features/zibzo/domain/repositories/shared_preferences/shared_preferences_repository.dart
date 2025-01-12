abstract class SharedPreferencesRepository {
  Future<void> login(String username);
  Future<bool> isLoggedIn();
  Future<void> logout();
}
