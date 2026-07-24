/// Biometric authentication gateway (Face ID / fingerprint).
abstract interface class BiometricGateway {
  Future<bool> get isAvailable;

  /// Returns true when the OS confirms a successful biometric unlock.
  Future<bool> authenticate({String reason = 'Authenticate to continue'});
}
