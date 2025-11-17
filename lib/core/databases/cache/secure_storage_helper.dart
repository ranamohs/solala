import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> saveToken({required String token}) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }


  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }
}