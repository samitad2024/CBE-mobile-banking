import 'package:cbe_mobile_banking/core/security/biometric_gateway.dart';
import 'package:local_auth/local_auth.dart';

class BiometricGatewayImpl implements BiometricGateway {
  BiometricGatewayImpl({LocalAuthentication? localAuth})
      : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  @override
  Future<bool> get isAvailable async {
    final canCheck = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    return canCheck || isDeviceSupported;
  }

  @override
  Future<bool> authenticate({
    String reason = 'Authenticate to continue',
  }) {
    return _localAuth.authenticate(
      localizedReason: reason,
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );
  }
}
