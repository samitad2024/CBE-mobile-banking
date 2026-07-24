import 'package:cbe_mobile_banking/core/constants/app_constants.dart';
import 'package:cbe_mobile_banking/core/error/exceptions.dart';
import 'package:cbe_mobile_banking/core/security/biometric_gateway.dart';
import 'package:cbe_mobile_banking/features/auth/data/models/session_model.dart';

/// Auth data contract — mock and remote share this interface.
abstract interface class AuthDataSource {
  Future<SessionModel> loginWithPin(String pin);

  Future<SessionModel> loginWithBiometrics();
}

class AuthMockDataSourceImpl implements AuthDataSource {
  AuthMockDataSourceImpl(this._biometricGateway);

  final BiometricGateway _biometricGateway;

  static const _mockSession = SessionModel(
    token: 'mock-session-token',
    customerName: 'Girma Belay Terunehe',
    accountNumber: '1000582007601',
  );

  @override
  Future<SessionModel> loginWithPin(String pin) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (pin != AppConstants.mockPin) {
      throw const AuthException('Invalid PIN');
    }
    return _mockSession;
  }

  @override
  Future<SessionModel> loginWithBiometrics() async {
    final ok = await _biometricGateway.authenticate(
      reason: 'Insert Pin or Use Biometrics to Log In',
    );
    if (!ok) {
      throw const AuthException('Biometric authentication failed');
    }
    return _mockSession;
  }
}
