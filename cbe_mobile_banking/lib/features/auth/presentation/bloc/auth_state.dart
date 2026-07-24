import 'package:cbe_mobile_banking/features/auth/domain/entities/session_entity.dart';
import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSuccess extends AuthState {
  const AuthSuccess(this.session);

  final SessionEntity session;

  @override
  List<Object?> get props => [session];
}

final class AuthFailureState extends AuthState {
  const AuthFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
