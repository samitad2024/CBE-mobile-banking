import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/auth/domain/entities/session_entity.dart';

/// Auth repository contract — domain only.
abstract interface class AuthRepository {
  Future<({Failure? failure, SessionEntity? session})> loginWithPin(String pin);

  Future<({Failure? failure, SessionEntity? session})> loginWithBiometrics();
}
