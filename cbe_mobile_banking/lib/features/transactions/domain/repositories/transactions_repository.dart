import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/entities/transaction_entity.dart';

abstract interface class TransactionsRepository {
  Future<({Failure? failure, List<TransactionEntity>? items})> getTransactions();

  Future<({Failure? failure, ReceiptEntity? receipt})> getReceipt(String id);
}
