import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/transactions/data/datasources/transactions_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/entities/transaction_entity.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/repositories/transactions_repository.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  TransactionsRepositoryImpl({
    required this._mockDataSource,
  });

  final TransactionsMockDataSource _mockDataSource;

  @override
  Future<({Failure? failure, List<TransactionEntity>? items})>
      getTransactions() async {
    try {
      final items = await _mockDataSource.fetchTransactions();
      return (failure: null, items: items);
    } on Exception {
      return (failure: const UnexpectedFailure(), items: null);
    }
  }

  @override
  Future<({Failure? failure, ReceiptEntity? receipt})> getReceipt(
    String id,
  ) async {
    try {
      final receipt = await _mockDataSource.fetchReceipt(id);
      return (failure: null, receipt: receipt);
    } on Exception {
      return (failure: const UnexpectedFailure(), receipt: null);
    }
  }
}
