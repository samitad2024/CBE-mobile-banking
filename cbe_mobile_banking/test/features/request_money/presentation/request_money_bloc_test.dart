import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/incoming_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/payment_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/repositories/request_money_repository.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/usecases/create_payment_request_usecase.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/bloc/request_money_bloc.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/bloc/request_money_event.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/bloc/request_money_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRequestRepository implements RequestMoneyRepository {
  int createCount = 0;

  @override
  Future<({Failure? failure, PaymentRequestEntity? request})> createRequest({
    required RequestMode mode,
    required double amountEtb,
    String? accountOrNote,
  }) async {
    createCount++;
    await Future<void>.delayed(const Duration(milliseconds: 30));
    return (
      failure: null,
      request: PaymentRequestEntity(
        mode: mode,
        amountEtb: amountEtb,
        accountOrNote: accountOrNote,
        qrPayload: mode == RequestMode.qr ? 'CBE|PAY|mock' : null,
      ),
    );
  }

  @override
  Future<({Failure? failure, List<IncomingRequestEntity>? items})>
      getPendingRequests() async {
    return (
      failure: null,
      items: const <IncomingRequestEntity>[],
    );
  }
}

void main() {
  late _FakeRequestRepository repo;
  late RequestMoneyBloc bloc;

  setUp(() {
    repo = _FakeRequestRepository();
    bloc = RequestMoneyBloc(
      createPaymentRequest: CreatePaymentRequestUseCase(repo),
    );
  });

  tearDown(() async => bloc.close());

  test('validates empty amount', () async {
    bloc.add(const RequestSubmitted(idempotencyKey: 'k0'));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    final state = bloc.state;
    expect(state, isA<RequestMoneyFormState>());
    expect(
      (state as RequestMoneyFormState).validationMessage,
      'Enter a valid amount',
    );
    expect(repo.createCount, 0);
  });

  test('qr request succeeds', () async {
    bloc
      ..add(const RequestAmountChanged('250'))
      ..add(const RequestSubmitted(idempotencyKey: 'k1'));
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(bloc.state, isA<RequestMoneySuccessState>());
    expect(repo.createCount, 1);
  });

  test('droppable double submit does not create twice', () async {
    bloc
      ..add(const RequestAmountChanged('100'))
      ..add(const RequestSubmitted(idempotencyKey: 'k2'))
      ..add(const RequestSubmitted(idempotencyKey: 'k2'));
    await Future<void>.delayed(const Duration(milliseconds: 80));
    expect(repo.createCount, 1);
    expect(bloc.state, isA<RequestMoneySuccessState>());
  });

  test('account mode requires account details', () async {
    bloc
      ..add(const RequestModeSelected(RequestMode.account))
      ..add(const RequestAmountChanged('50'))
      ..add(const RequestSubmitted(idempotencyKey: 'k3'));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    final state = bloc.state;
    expect(state, isA<RequestMoneyFormState>());
    expect(
      (state as RequestMoneyFormState).validationMessage,
      'Enter account details',
    );
  });
}
