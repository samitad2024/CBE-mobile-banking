import 'package:cbe_mobile_banking/features/auth/domain/entities/session_entity.dart';
import 'package:equatable/equatable.dart';

sealed class AuthSessionEvent extends Equatable {
  const AuthSessionEvent();

  @override
  List<Object?> get props => [];
}

final class AuthSessionRestoreRequested extends AuthSessionEvent {
  const AuthSessionRestoreRequested();
}

final class AuthSessionLoggedIn extends AuthSessionEvent {
  const AuthSessionLoggedIn(this.session);

  final SessionEntity session;

  @override
  List<Object?> get props => [session];
}

final class AuthSessionLoggedOut extends AuthSessionEvent {
  const AuthSessionLoggedOut();
}

final class AuthSessionExpired extends AuthSessionEvent {
  const AuthSessionExpired();
}
