import 'package:cbe_mobile_banking/features/auth/domain/usecases/login_with_biometrics_usecase.dart';
import 'package:cbe_mobile_banking/features/auth/domain/usecases/login_with_pin_usecase.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_event.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this._loginWithPin,
    required this._loginWithBiometrics,
  })  : super(const AuthInitial()) {
    on<AuthPinSubmitted>(_onPinSubmitted);
    on<AuthBiometricRequested>(_onBiometricRequested);
  }

  final LoginWithPinUseCase _loginWithPin;
  final LoginWithBiometricsUseCase _loginWithBiometrics;

  Future<void> _onPinSubmitted(
    AuthPinSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _loginWithPin(event.pin);
    if (result.failure != null) {
      emit(AuthFailureState(result.failure!.message));
      return;
    }
    emit(AuthSuccess(result.session!));
  }

  Future<void> _onBiometricRequested(
    AuthBiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _loginWithBiometrics();
    if (result.failure != null) {
      emit(AuthFailureState(result.failure!.message));
      return;
    }
    emit(AuthSuccess(result.session!));
  }
}
