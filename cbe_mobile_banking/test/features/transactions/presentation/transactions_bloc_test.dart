import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/entities/transaction_entity.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/usecases/transactions_usecases.dart';
import 'package:cbe_mobile_banking/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:cbe_mobile_banking/features/transactions/presentation/bloc/transactions_event.dart';
import 'package:cbe_mobile_banking/features/transactions/presentation/bloc/transactions_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements TransactionsRepository {
  @override
  Future<({Failure? failure, List<TransactionEntity>? items})>
      getTransactions() async {
    return (
      failure: null,
      items: [
        TransactionEntity(
          id: '1',
          title: 'House Rent',
          amountEtb: 25000,
          direction: TransactionDirection.debit,
          occurredAt: DateTime(2024, 12, 25),
        ),
      ],
    );
  }

  @override
  Future<({Failure? failure, ReceiptEntity? receipt})> getReceipt(
    String id,
  ) async {
    return (
      failure: null,
      receipt: const ReceiptEntity(
        transactionNumber: 'FT1',
        amountEtb: 25000,
        receiverName: 'Landlord',
        receiverNumber: '1000',
      ),
    );
  }
}

void main() {
  late TransactionsBloc bloc;

  setUp(() {
    final repo = _FakeRepo();
    bloc = TransactionsBloc(
      getTransactions: GetTransactionsUseCase(repo),
      getReceipt: GetReceiptUseCase(repo),
    );
  });

  tearDown(() async => bloc.close());

  test('loads list then opens and dismisses receipt', () async {
    bloc.add(const TransactionsStarted());
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(bloc.state, isA<TransactionsLoaded>());
    expect((bloc.state as TransactionsLoaded).items, hasLength(1));

    bloc.add(const TransactionSelected('1'));
    await Future<void>.delayed(const Duration(milliseconds: 40));
    final loaded = bloc.state as TransactionsLoaded;
    expect(loaded.selectedReceipt?.transactionNumber, 'FT1');

    bloc.add(const ReceiptDismissed());
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect((bloc.state as TransactionsLoaded).selectedReceipt, isNull);
  });
}
