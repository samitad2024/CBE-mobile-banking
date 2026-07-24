import 'package:cbe_mobile_banking/features/transactions/domain/entities/transaction_entity.dart';

abstract interface class TransactionsMockDataSource {
  Future<List<TransactionEntity>> fetchTransactions();

  Future<ReceiptEntity> fetchReceipt(String id);
}

class TransactionsMockDataSourceImpl implements TransactionsMockDataSource {
  static final _when = DateTime(2024, 12, 25, 9, 31);

  @override
  Future<List<TransactionEntity>> fetchTransactions() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return [
      TransactionEntity(
        id: '1',
        title: 'House Rent',
        amountEtb: 25000,
        direction: TransactionDirection.debit,
        occurredAt: _when,
      ),
      TransactionEntity(
        id: '2',
        title: 'Transfer via Tele Birr',
        amountEtb: 15000,
        direction: TransactionDirection.credit,
        occurredAt: _when,
        partnerLabel: 'Telebirr',
      ),
      TransactionEntity(
        id: '3',
        title: 'Charity',
        amountEtb: 300,
        direction: TransactionDirection.credit,
        occurredAt: _when,
      ),
      TransactionEntity(
        id: '4',
        title: 'Transfer via Abyssinia',
        amountEtb: 50000,
        direction: TransactionDirection.credit,
        occurredAt: _when,
        partnerLabel: 'Abyssinia',
      ),
      TransactionEntity(
        id: '5',
        title: 'Supermarket',
        amountEtb: 1205,
        direction: TransactionDirection.debit,
        occurredAt: _when,
      ),
    ];
  }

  @override
  Future<ReceiptEntity> fetchReceipt(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return const ReceiptEntity(
      transactionNumber: 'FT2455161RQL1H',
      amountEtb: 50000,
      receiverName: 'Mamo Muluken Gebeye',
      receiverNumber: '0930888495 via Telebirr',
    );
  }
}
