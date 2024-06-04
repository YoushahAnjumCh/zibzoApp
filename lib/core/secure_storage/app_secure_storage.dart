import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//TODO : we need to pass token in every api call
abstract class AppSecureStorage {
  Future<void> writeToStorage(String key, String value);
  Future<String?> readFromStorage(String key);
  Future<void> deleteFromStorage(String key);
}

class FlutterSecureStorageAdapter implements AppSecureStorage {
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
