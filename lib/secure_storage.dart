import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///this class provides secure storage
class SecureStorage {
  ///an instance of FlutterSecureStorage
  final _storage = const FlutterSecureStorage();

  ///writes data to secure storage
  Future<void> writeData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
///reads data from the secure storage
  Future<String?> readData(String key) async {
    return await _storage.read(key: key);
  }

  ///deletes data from secure storage
  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  ///clears all data from secure storage.
  Future<void> clearData() async {
    await _storage.deleteAll();
  }
}
