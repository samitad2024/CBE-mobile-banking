import 'package:cbe_mobile_banking/core/error/exceptions.dart';
import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/core/security/session_manager.dart';
import 'package:cbe_mobile_banking/features/auth/data/datasources/auth_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/auth/data/mappers/session_mapper.dart';
import 'package:cbe_mobile_banking/features/auth/domain/entities/session_entity.dart';
import 'package:cbe_mobile_banking/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this._dataSource,
    required this._sessionManager,
  });

  final AuthDataSource _dataSource;
  final SessionManager _sessionManager;

  @override
  Future<({Failure? failure, SessionEntity? session})> loginWithPin(
    String pin,
  ) async {
    try {
      final model = await _dataSource.loginWithPin(pin);
      final session = SessionMapper.toEntity(model);
      _sessionManager.setSession(token: session.token);
      return (failure: null, session: session);
    } on AuthException catch (e) {
      return (failure: AuthFailure(e.message), session: null);
    } on NetworkException catch (e) {
      return (failure: NetworkFailure(e.message), session: null);
    } on ServerException catch (e) {
      return (failure: ServerFailure(e.message), session: null);
    } on Exception {
      return (failure: const UnexpectedFailure(), session: null);
    }
  }

  @override
  Future<({Failure? failure, SessionEntity? session})>
      loginWithBiometrics() async {
    try {
      final model = await _dataSource.loginWithBiometrics();
      final session = SessionMapper.toEntity(model);
      _sessionManager.setSession(token: session.token);
      return (failure: null, session: session);
    } on AuthException catch (e) {
      return (failure: AuthFailure(e.message), session: null);
    } on NetworkException catch (e) {
      return (failure: NetworkFailure(e.message), session: null);
    } on ServerException catch (e) {
      return (failure: ServerFailure(e.message), session: null);
    } on Exception {
      return (failure: const UnexpectedFailure(), session: null);
    }
  }
}
