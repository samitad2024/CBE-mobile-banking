import 'package:cbe_mobile_banking/core/security/secure_storage_gateway.dart';

/// In-memory secure storage for mock / unit tests.
class InMemorySecureStorageGateway implements SecureStorageGateway {
  final Map<String, String> _store = {};

  @override
  Future<void> write({required String key, required String value}) async {
    _store[key] = value;
  }

  @override
  Future<String?> read({required String key}) async => _store[key];

  @override
  Future<void> delete({required String key}) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async => _store.clear();
}
