import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_prefill.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/repositories/transfer_repository.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/usecases/submit_transfer_usecase.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/bloc/transfer_bloc.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/bloc/transfer_event.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/bloc/transfer_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTransferRepository implements TransferRepository {
  int submitCount = 0;

  @override
  Future<({Failure? failure, TransferResultEntity? result})> submitTransfer(
    TransferDraftEntity draft,
  ) async {
    submitCount++;
    return (
      failure: null,
      result: TransferResultEntity(
        transactionId: 'T1',
        amountEtb: draft.amountEtb,
        receiverName: draft.receiverName,
        destination: draft.destination,
        message: 'ok',
      ),
    );
  }
}

void main() {
  late _FakeTransferRepository repo;
  late TransferBloc bloc;

  setUp(() {
    repo = _FakeTransferRepository();
    bloc = TransferBloc(submitTransfer: SubmitTransferUseCase(repo));
  });

  tearDown(() async => bloc.close());

  test('form → confirm → success', () async {
    bloc
      ..add(const TransferReceiverChanged('Ada'))
      ..add(const TransferDestinationChanged('1000'))
      ..add(const TransferAmountChanged('100'))
      ..add(const TransferReviewRequested());
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(bloc.state, isA<TransferConfirmState>());

    bloc.add(const TransferConfirmed(idempotencyKey: 'k1'));
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(bloc.state, isA<TransferSuccessState>());
    expect(repo.submitCount, 1);
  });

  test('droppable double confirm does not double-submit', () async {
    bloc
      ..add(const TransferReceiverChanged('Ada'))
      ..add(const TransferDestinationChanged('1000'))
      ..add(const TransferAmountChanged('100'))
      ..add(const TransferReviewRequested());
    await Future<void>.delayed(const Duration(milliseconds: 40));

    bloc
      ..add(const TransferConfirmed(idempotencyKey: 'k2'))
      ..add(const TransferConfirmed(idempotencyKey: 'k2'));
    await Future<void>.delayed(const Duration(milliseconds: 80));
    expect(repo.submitCount, 1);
  });

  test('dismiss confirm restores form with draft values', () async {
    bloc
      ..add(const TransferReceiverChanged('Ada'))
      ..add(const TransferDestinationChanged('1000'))
      ..add(const TransferAmountChanged('100'))
      ..add(const TransferReviewRequested());
    await Future<void>.delayed(const Duration(milliseconds: 40));

    bloc.add(const TransferConfirmDismissed());
    await Future<void>.delayed(const Duration(milliseconds: 20));
    final form = bloc.state;
    expect(form, isA<TransferFormState>());
    form as TransferFormState;
    expect(form.receiverName, 'Ada');
    expect(form.destination, '1000');
  });

  test('TransferStarted with prefill seeds form', () async {
    bloc.add(
      const TransferStarted(
        prefill: TransferPrefill(
          rail: TransferRail.payment,
          receiverName: 'QR Payment',
          destination: 'MOCK',
          amountText: '50000',
        ),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));
    final form = bloc.state;
    expect(form, isA<TransferFormState>());
    form as TransferFormState;
    expect(form.rail, TransferRail.payment);
    expect(form.destination, 'MOCK');
    expect(form.amountText, '50000');
  });
}
