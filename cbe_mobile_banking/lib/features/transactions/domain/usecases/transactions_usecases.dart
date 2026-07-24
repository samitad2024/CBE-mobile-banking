import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/entities/transaction_entity.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/repositories/transactions_repository.dart';

class GetTransactionsUseCase {
  GetTransactionsUseCase(this._repository);

  final TransactionsRepository _repository;

  Future<({Failure? failure, List<TransactionEntity>? items})> call() {
    return _repository.getTransactions();
  }
}

class GetReceiptUseCase {
  GetReceiptUseCase(this._repository);

  final TransactionsRepository _repository;

  Future<({Failure? failure, ReceiptEntity? receipt})> call(String id) {
    return _repository.getReceipt(id);
  }
}
