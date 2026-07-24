import 'package:cbe_mobile_banking/core/constants/app_constants.dart';
import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/auth/domain/entities/session_entity.dart';
import 'package:cbe_mobile_banking/features/auth/domain/repositories/auth_repository.dart';
import 'package:cbe_mobile_banking/features/auth/domain/usecases/login_with_biometrics_usecase.dart';
import 'package:cbe_mobile_banking/features/auth/domain/usecases/login_with_pin_usecase.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_event.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<({Failure? failure, SessionEntity? session})> loginWithBiometrics() async {
    return (
      failure: null,
      session: const SessionEntity(
        token: 'bio',
        customerName: 'Bio User',
        accountNumber: '1000',
      ),
    );
  }

  @override
  Future<({Failure? failure, SessionEntity? session})> loginWithPin(
    String pin,
  ) async {
    if (pin == AppConstants.mockPin) {
      return (
        failure: null,
        session: const SessionEntity(
          token: 'pin',
          customerName: 'Pin User',
          accountNumber: '1000',
        ),
      );
    }
    return (failure: const AuthFailure('Invalid PIN'), session: null);
  }
}

void main() {
  late AuthBloc bloc;

  setUp(() {
    final repo = _FakeAuthRepository();
    bloc = AuthBloc(
      loginWithPin: LoginWithPinUseCase(repo),
      loginWithBiometrics: LoginWithBiometricsUseCase(repo),
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  test('emits [loading, success] on valid PIN', () async {
    final states = <AuthState>[];
    final sub = bloc.stream.listen(states.add);

    bloc.add(const AuthPinSubmitted(AppConstants.mockPin));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await sub.cancel();

    expect(states.first, isA<AuthLoading>());
    expect(states.last, isA<AuthSuccess>());
  });

  test('emits [loading, failure] on invalid PIN', () async {
    final states = <AuthState>[];
    final sub = bloc.stream.listen(states.add);

    bloc.add(const AuthPinSubmitted('0000'));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await sub.cancel();

    expect(states.first, isA<AuthLoading>());
    expect(states.last, isA<AuthFailureState>());
  });
}
