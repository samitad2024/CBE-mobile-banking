import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthPinSubmitted extends AuthEvent {
  const AuthPinSubmitted(this.pin);

  final String pin;

  @override
  List<Object?> get props => [pin];
}

final class AuthBiometricRequested extends AuthEvent {
  const AuthBiometricRequested();
}
