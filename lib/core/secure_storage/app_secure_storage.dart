import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppLocalStorage {
  Future<void> writeToStorage(String key, String value);
  Future<String?> readFromStorage(String key);
  Future<void> deleteFromStorage(String key);
}

class FlutterSecureStorageAdapter implements AppLocalStorage {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> writeToStorage(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> readFromStorage(String key) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> deleteFromStorage(String key) async {
    await _storage.delete(key: key);
  }
}

class FlutterSharedPreferenceStorageAdapter implements AppLocalStorage {
  final SharedPreferences _sharedPreferences;
  FlutterSharedPreferenceStorageAdapter(this._sharedPreferences);
  @override
  Future<void> writeToStorage(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  @override
  Future<String?> readFromStorage(String key) async {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<void> deleteFromStorage(String key) async {
    await _sharedPreferences.remove(key);
  }
}
