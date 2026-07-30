import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageService {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage(
    // ignore: deprecated_member_use
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static Future<void> writeData({
    required String key,
    required String value,
  }) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      debugPrint("Error writing to secure storage: $e");
    }
  }

  static Future<String?> readData({required String key}) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      debugPrint("Error reading from secure storage: $e");
      return null;
    }
  }

  static Future<bool> readBool({required String key}) async {
    final value = await readData(key: key);
    return value == 'true';
  }

  static Future<void> deleteData({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      debugPrint("Error deleting from secure storage: $e");
    }
  }

  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint("Error clearing secure storage: $e");
    }
  }
}
