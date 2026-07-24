import 'package:cbe_mobile_banking/features/transactions/domain/entities/transaction_entity.dart';

/// Transactions data contract — mock and remote share this interface.
abstract interface class TransactionsDataSource {
  Future<List<TransactionEntity>> fetchTransactions();

  Future<ReceiptEntity> fetchReceipt(String id);
}

class TransactionsMockDataSourceImpl implements TransactionsDataSource {
  @override
  Future<List<TransactionEntity>> fetchTransactions() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return [
      TransactionEntity(
        id: '1',
        title: 'House Rent',
        amountEtb: 25000,
        direction: TransactionDirection.debit,
        occurredAt: DateTime(2024, 12, 25, 9, 31),
      ),
      TransactionEntity(
        id: '2',
        title: 'Transfer via Tele Birr',
        amountEtb: 15000,
        direction: TransactionDirection.credit,
        occurredAt: DateTime(2024, 12, 24, 18, 12),
        partnerLabel: 'Telebirr',
      ),
      TransactionEntity(
        id: '3',
        title: 'Charity',
        amountEtb: 300,
        direction: TransactionDirection.credit,
        occurredAt: DateTime(2024, 12, 24, 11, 5),
      ),
      TransactionEntity(
        id: '4',
        title: 'Transfer via Abyssinia',
        amountEtb: 50000,
        direction: TransactionDirection.credit,
        occurredAt: DateTime(2024, 12, 23, 14, 40),
        partnerLabel: 'Abyssinia',
      ),
      TransactionEntity(
        id: '5',
        title: 'Supermarket',
        amountEtb: 1205,
        direction: TransactionDirection.debit,
        occurredAt: DateTime(2024, 12, 22, 16, 20),
      ),
      TransactionEntity(
        id: '6',
        title: 'Salary',
        amountEtb: 100000,
        direction: TransactionDirection.credit,
        occurredAt: DateTime(2024, 12, 20, 9),
        partnerLabel: 'CBE',
      ),
    ];
  }

  @override
  Future<ReceiptEntity> fetchReceipt(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return switch (id) {
      '2' => const ReceiptEntity(
          transactionNumber: 'FT2455161RQL1H',
          amountEtb: 15000,
          receiverName: 'Girma Belay Terunehe',
          receiverNumber: '0930888495 via Telebirr',
        ),
      '4' => const ReceiptEntity(
          transactionNumber: 'FT7413103RYT',
          amountEtb: 50000,
          receiverName: 'Mamo Muluken Gebeye',
          receiverNumber: '1000 ******** 8821 via Abyssinia',
        ),
      _ => ReceiptEntity(
          transactionNumber: 'FT2455161RQL1H',
          amountEtb: id == '1' ? 25000 : 1205,
          receiverName: 'Merchant / Counterparty',
          receiverNumber: '**** via CBE',
        ),
    };
  }
}
