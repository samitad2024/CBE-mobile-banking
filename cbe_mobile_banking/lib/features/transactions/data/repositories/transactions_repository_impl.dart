import 'package:cbe_mobile_banking/core/error/exceptions.dart';
import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/transactions/data/datasources/transactions_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/entities/transaction_entity.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/repositories/transactions_repository.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  TransactionsRepositoryImpl({required this._dataSource});

  final TransactionsDataSource _dataSource;

  @override
  Future<({Failure? failure, List<TransactionEntity>? items})>
      getTransactions() async {
    try {
      final items = await _dataSource.fetchTransactions();
      return (failure: null, items: items);
    } on NetworkException catch (e) {
      return (failure: NetworkFailure(e.message), items: null);
    } on ServerException catch (e) {
      return (failure: ServerFailure(e.message), items: null);
    } on AuthException catch (e) {
      return (failure: AuthFailure(e.message), items: null);
    } on Exception {
      return (failure: const UnexpectedFailure(), items: null);
    }
  }

  @override
  Future<({Failure? failure, ReceiptEntity? receipt})> getReceipt(
    String id,
  ) async {
    try {
      final receipt = await _dataSource.fetchReceipt(id);
      return (failure: null, receipt: receipt);
    } on NetworkException catch (e) {
      return (failure: NetworkFailure(e.message), receipt: null);
    } on ServerException catch (e) {
      return (failure: ServerFailure(e.message), receipt: null);
    } on AuthException catch (e) {
      return (failure: AuthFailure(e.message), receipt: null);
    } on Exception {
      return (failure: const UnexpectedFailure(), receipt: null);
    }
  }
}
