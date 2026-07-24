import 'package:cbe_mobile_banking/features/auth/domain/entities/session_entity.dart';
import 'package:equatable/equatable.dart';

sealed class AuthSessionState extends Equatable {
  const AuthSessionState();

  @override
  List<Object?> get props => [];

  bool get isAuthenticated => this is AuthSessionAuthenticated;
}

final class AuthSessionUnknown extends AuthSessionState {
  const AuthSessionUnknown();
}

final class AuthSessionAuthenticated extends AuthSessionState {
  const AuthSessionAuthenticated(this.session);

  final SessionEntity session;

  @override
  List<Object?> get props => [session];
}

final class AuthSessionUnauthenticated extends AuthSessionState {
  const AuthSessionUnauthenticated();
}
