import 'package:cbe_mobile_banking/core/security/biometric_gateway.dart';

/// Always-succeeds biometric stub for mock / web development.
class MockBiometricGateway implements BiometricGateway {
  @override
  Future<bool> get isAvailable async => true;

  @override
  Future<bool> authenticate({
    String reason = 'Authenticate to continue',
  }) async =>
      true;
}
