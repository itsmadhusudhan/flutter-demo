import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// NO NEED TO CREATE ABSTRACTION OVER SECURE STORAGE AS IT IS ALREADY AN ABSTRACTION
abstract class ISecureStorage {
  Future<String?> read(String key);
}

class SecureStorage implements ISecureStorage {
  final FlutterSecureStorage secureStorage;

  SecureStorage({required this.secureStorage});

  @override
  Future<String?> read(String key) {
    return secureStorage.read(key: key);
  }
}
