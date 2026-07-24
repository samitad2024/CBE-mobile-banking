import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';

/// Transfer data contract — mock and remote share this interface.
abstract interface class TransferDataSource {
  Future<TransferResultEntity> submit(TransferDraftEntity draft);
}

class TransferMockDataSourceImpl implements TransferDataSource {
  @override
  Future<TransferResultEntity> submit(TransferDraftEntity draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return TransferResultEntity(
      transactionId: 'FT7413103RYT',
      amountEtb: draft.amountEtb,
      receiverName: draft.receiverName,
      destination: draft.destination,
      message:
          'ETB ${draft.amountEtb.toStringAsFixed(2)} transferred successfully '
          '(mock) with transaction ID: FT7413103RYT.',
    );
  }
}
