import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/transfer/data/datasources/transfer_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/repositories/transfer_repository.dart';

class TransferRepositoryImpl implements TransferRepository {
  TransferRepositoryImpl({required this._mockDataSource});

  final TransferMockDataSource _mockDataSource;

  @override
  Future<({Failure? failure, TransferResultEntity? result})> submitTransfer(
    TransferDraftEntity draft,
  ) async {
    try {
      final result = await _mockDataSource.submit(draft);
      return (failure: null, result: result);
    } on Exception {
      return (failure: const UnexpectedFailure(), result: null);
    }
  }
}
