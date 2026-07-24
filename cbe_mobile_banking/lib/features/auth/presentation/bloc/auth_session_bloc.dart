import 'package:cbe_mobile_banking/features/auth/domain/usecases/session_usecases.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_event.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// App-scoped session. Persists token only — never PIN.
class AuthSessionBloc extends Bloc<AuthSessionEvent, AuthSessionState> {
  AuthSessionBloc({
    required this._restoreSession,
    required this._persistSession,
    required this._clearSession,
  })  : super(const AuthSessionUnknown()) {
    on<AuthSessionRestoreRequested>(_onRestore);
    on<AuthSessionLoggedIn>(_onLoggedIn);
    on<AuthSessionLoggedOut>(_onLoggedOut);
    on<AuthSessionExpired>(_onExpired);
  }

  final RestoreSessionUseCase _restoreSession;
  final PersistSessionUseCase _persistSession;
  final ClearSessionUseCase _clearSession;

  Future<void> _onRestore(
    AuthSessionRestoreRequested event,
    Emitter<AuthSessionState> emit,
  ) async {
    final result = await _restoreSession();
    if (result.failure != null || result.session == null) {
      emit(const AuthSessionUnauthenticated());
      return;
    }
    emit(AuthSessionAuthenticated(result.session!));
  }

  Future<void> _onLoggedIn(
    AuthSessionLoggedIn event,
    Emitter<AuthSessionState> emit,
  ) async {
    await _persistSession(event.session);
    emit(AuthSessionAuthenticated(event.session));
  }

  Future<void> _onLoggedOut(
    AuthSessionLoggedOut event,
    Emitter<AuthSessionState> emit,
  ) async {
    await _clearSession();
    emit(const AuthSessionUnauthenticated());
  }

  Future<void> _onExpired(
    AuthSessionExpired event,
    Emitter<AuthSessionState> emit,
  ) async {
    await _clearSession();
    emit(const AuthSessionUnauthenticated());
  }
}
