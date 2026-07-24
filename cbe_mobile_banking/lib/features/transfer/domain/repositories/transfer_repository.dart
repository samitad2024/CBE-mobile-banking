import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';

abstract interface class TransferRepository {
  Future<({Failure? failure, TransferResultEntity? result})> submitTransfer(
    TransferDraftEntity draft,
  );
}
