import 'package:cbe_mobile_banking/core/error/exceptions.dart';
import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/transfer/data/datasources/transfer_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/repositories/transfer_repository.dart';

class TransferRepositoryImpl implements TransferRepository {
  TransferRepositoryImpl({required this._dataSource});

  final TransferDataSource _dataSource;

  @override
  Future<({Failure? failure, TransferResultEntity? result})> submitTransfer(
    TransferDraftEntity draft,
  ) async {
    try {
      final result = await _dataSource.submit(draft);
      return (failure: null, result: result);
    } on NetworkException catch (e) {
      return (failure: NetworkFailure(e.message), result: null);
    } on ServerException catch (e) {
      return (failure: ServerFailure(e.message), result: null);
    } on AuthException catch (e) {
      return (failure: AuthFailure(e.message), result: null);
    } on Exception {
      return (failure: const UnexpectedFailure(), result: null);
    }
  }
}
