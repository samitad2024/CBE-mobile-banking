import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/auth/domain/entities/session_entity.dart';
import 'package:cbe_mobile_banking/features/auth/domain/repositories/session_repository.dart';
import 'package:cbe_mobile_banking/features/auth/domain/usecases/session_usecases.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_event.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSessionRepository implements SessionRepository {
  SessionEntity? stored;

  @override
  Future<Failure?> clear() async {
    stored = null;
    return null;
  }

  @override
  Future<Failure?> persist(SessionEntity session) async {
    stored = session;
    return null;
  }

  @override
  Future<({Failure? failure, SessionEntity? session})> restore() async {
    return (failure: null, session: stored);
  }
}

void main() {
  late _FakeSessionRepository repo;
  late AuthSessionBloc bloc;

  setUp(() {
    repo = _FakeSessionRepository();
    bloc = AuthSessionBloc(
      restoreSession: RestoreSessionUseCase(repo),
      persistSession: PersistSessionUseCase(repo),
      clearSession: ClearSessionUseCase(repo),
    );
  });

  tearDown(() async => bloc.close());

  test('restore with no session → unauthenticated', () async {
    bloc.add(const AuthSessionRestoreRequested());
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(bloc.state, isA<AuthSessionUnauthenticated>());
  });

  test('login then restore → authenticated', () async {
    const session = SessionEntity(
      token: 't',
      customerName: 'User',
      accountNumber: '1000',
    );
    bloc.add(const AuthSessionLoggedIn(session));
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(bloc.state, isA<AuthSessionAuthenticated>());

    bloc.add(const AuthSessionLoggedOut());
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(bloc.state, isA<AuthSessionUnauthenticated>());
  });
}
