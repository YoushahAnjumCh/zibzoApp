import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';

abstract class AppLocalStorage {
  Future<void> saveToken([String key = StringConstant.authToken, String value]);
  Future<String?> getToken([String key = StringConstant.authToken]);
  Future<void> clearToken([String key = StringConstant.authToken]);
  Future<bool> isLoggedIn();
}

class FlutterSecureStorageAdapter implements AppLocalStorage {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> saveToken(
      [String key = StringConstant.authToken, String? value]) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> getToken([String key = StringConstant.authToken]) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> clearToken([String key = StringConstant.authToken]) async {
    await _storage.delete(key: key);
  }

  @override
  Future<bool> isLoggedIn() async {
    String? token = await getToken(StringConstant.authToken);
    return token != null;
  }
}
