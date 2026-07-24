import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/auth/domain/entities/session_entity.dart';
import 'package:cbe_mobile_banking/features/auth/domain/repositories/session_repository.dart';

class RestoreSessionUseCase {
  RestoreSessionUseCase(this._repository);

  final SessionRepository _repository;

  Future<({Failure? failure, SessionEntity? session})> call() {
    return _repository.restore();
  }
}

class PersistSessionUseCase {
  PersistSessionUseCase(this._repository);

  final SessionRepository _repository;

  Future<Failure?> call(SessionEntity session) {
    return _repository.persist(session);
  }
}

class ClearSessionUseCase {
  ClearSessionUseCase(this._repository);

  final SessionRepository _repository;

  Future<Failure?> call() => _repository.clear();
}
