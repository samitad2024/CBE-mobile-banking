import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/repositories/transfer_repository.dart';

class SubmitTransferUseCase {
  SubmitTransferUseCase(this._repository);

  final TransferRepository _repository;

  Future<({Failure? failure, TransferResultEntity? result})> call(
    TransferDraftEntity draft,
  ) {
    if (draft.amountEtb <= 0 || draft.destination.trim().isEmpty) {
      return Future.value(
        (
          failure: const ValidationFailure('Invalid transfer details'),
          result: null,
        ),
      );
    }
    return _repository.submitTransfer(draft);
  }
}
