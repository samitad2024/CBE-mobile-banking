/// Secure key-value storage abstraction (PIN hash, session token, flags).
/// Implementations must never log values.
abstract interface class SecureStorageGateway {
  Future<void> write({required String key, required String value});

  Future<String?> read({required String key});

  Future<void> delete({required String key});

  Future<void> clear();
}
