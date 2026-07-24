import 'package:cbe_mobile_banking/core/security/secure_storage_gateway.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageGatewayImpl implements SecureStorageGateway {
  SecureStorageGatewayImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }

  @override
  Future<void> clear() => _storage.deleteAll();
}
