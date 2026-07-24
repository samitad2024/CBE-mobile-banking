import 'package:cbe_mobile_banking/core/constants/app_constants.dart';
import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/auth/domain/entities/session_entity.dart';
import 'package:cbe_mobile_banking/features/auth/domain/repositories/auth_repository.dart';
import 'package:cbe_mobile_banking/features/auth/domain/usecases/login_with_pin_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<({Failure? failure, SessionEntity? session})> loginWithBiometrics() {
    throw UnimplementedError();
  }

  @override
  Future<({Failure? failure, SessionEntity? session})> loginWithPin(
    String pin,
  ) async {
    if (pin == AppConstants.mockPin) {
      return (
        failure: null,
        session: const SessionEntity(
          token: 't',
          customerName: 'Test User',
          accountNumber: '1000',
        ),
      );
    }
    return (failure: const AuthFailure('Invalid PIN'), session: null);
  }
}

void main() {
  late LoginWithPinUseCase useCase;

  setUp(() {
    useCase = LoginWithPinUseCase(_FakeAuthRepository());
  });

  test('returns session when PIN is correct', () async {
    final result = await useCase(AppConstants.mockPin);
    expect(result.failure, isNull);
    expect(result.session?.customerName, 'Test User');
  });

  test('returns AuthFailure when PIN is wrong', () async {
    final result = await useCase('0000');
    expect(result.session, isNull);
    expect(result.failure, isA<AuthFailure>());
  });
}
