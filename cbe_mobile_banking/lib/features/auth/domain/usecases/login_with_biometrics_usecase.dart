import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/auth/domain/entities/session_entity.dart';
import 'package:cbe_mobile_banking/features/auth/domain/repositories/auth_repository.dart';

class LoginWithBiometricsUseCase {
  LoginWithBiometricsUseCase(this._repository);

  final AuthRepository _repository;

  Future<({Failure? failure, SessionEntity? session})> call() {
    return _repository.loginWithBiometrics();
  }
}
