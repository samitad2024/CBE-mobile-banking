import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/core/security/secure_storage_gateway.dart';
import 'package:cbe_mobile_banking/core/security/session_manager.dart';
import 'package:cbe_mobile_banking/features/auth/domain/entities/session_entity.dart';
import 'package:cbe_mobile_banking/features/auth/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl({
    required this._secureStorage,
    required this._sessionManager,
  });

  static const _tokenKey = 'session_token';
  static const _nameKey = 'session_customer_name';
  static const _accountKey = 'session_account_number';

  final SecureStorageGateway _secureStorage;
  final SessionManager _sessionManager;

  @override
  Future<({Failure? failure, SessionEntity? session})> restore() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      if (token == null || token.isEmpty) {
        return (failure: null, session: null);
      }
      final name = await _secureStorage.read(key: _nameKey) ?? '';
      final account = await _secureStorage.read(key: _accountKey) ?? '';
      _sessionManager.setSession(token: token);
      return (
        failure: null,
        session: SessionEntity(
          token: token,
          customerName: name,
          accountNumber: account,
        ),
      );
    } on Exception {
      return (failure: const CacheFailure(), session: null);
    }
  }

  @override
  Future<Failure?> persist(SessionEntity session) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: session.token);
      await _secureStorage.write(key: _nameKey, value: session.customerName);
      await _secureStorage.write(
        key: _accountKey,
        value: session.accountNumber,
      );
      _sessionManager.setSession(token: session.token);
      return null;
    } on Exception {
      return const CacheFailure();
    }
  }

  @override
  Future<Failure?> clear() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _nameKey);
      await _secureStorage.delete(key: _accountKey);
      _sessionManager.clear();
      return null;
    } on Exception {
      return const CacheFailure();
    }
  }
}
