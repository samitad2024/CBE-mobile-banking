import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/auth/domain/entities/session_entity.dart';

abstract interface class SessionRepository {
  Future<({Failure? failure, SessionEntity? session})> restore();

  Future<Failure?> persist(SessionEntity session);

  Future<Failure?> clear();
}
