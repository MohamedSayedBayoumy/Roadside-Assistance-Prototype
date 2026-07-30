import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService._internal();
  static final HiveService instance = HiveService._internal();

  static const String _encryptionKeyName = 'hive_secure_aes_key';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  List<int>? _encryptionCipherKey;

  Future<void> init() async {
    await Hive.initFlutter();
    _encryptionCipherKey = await _getOrCreateEncryptionKey();
  }

  Future<List<int>> _getOrCreateEncryptionKey() async {
    final existingKey = await _secureStorage.read(key: _encryptionKeyName);

    if (existingKey == null) {
      final newKey = Hive.generateSecureKey();
      await _secureStorage.write(
        key: _encryptionKeyName,
        value: base64UrlEncode(newKey),
      );
      return newKey;
    } else {
      return base64Url.decode(existingKey);
    }
  }

  Future<Box<T>> openEncryptedBox<T>(String boxName) async {
    if (_encryptionCipherKey == null) {
      throw Exception(
        'HiveService is not initialized. Call HiveService.instance.init() first.',
      );
    }

    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }

    return await Hive.openBox<T>(
      boxName,
      encryptionCipher: HiveAesCipher(_encryptionCipherKey!),
    );
  }

  Future<void> saveData<T>({
    required String boxName,
    required String key,
    required T value,
  }) async {
    final box = await openEncryptedBox<T>(boxName);
    await box.put(key, value);
  }

  Future<T?> getData<T>({
    required String boxName,
    required String key,
    T? defaultValue,
  }) async {
    final box = await openEncryptedBox<T>(boxName);
    return box.get(key, defaultValue: defaultValue);
  }

  Future<void> deleteData<T>({
    required String boxName,
    required String key,
  }) async {
    final box = await openEncryptedBox<T>(boxName);
    await box.delete(key);
  }

  Future<bool> containsKey<T>({
    required String boxName,
    required String key,
  }) async {
    final box = await openEncryptedBox<T>(boxName);
    return box.containsKey(key);
  }

  Future<void> clearBox<T>(String boxName) async {
    final box = await openEncryptedBox<T>(boxName);
    await box.clear();
  }

  Future<void> closeBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box<T>(boxName).close();
    }
  }
}
