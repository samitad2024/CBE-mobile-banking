import 'package:cbe_mobile_banking/features/request_money/domain/entities/payment_request_entity.dart';

abstract interface class RequestMoneyMockDataSource {
  Future<PaymentRequestEntity> create({
    required RequestMode mode,
    required double amountEtb,
    String? accountOrNote,
  });
}

class RequestMoneyMockDataSourceImpl implements RequestMoneyMockDataSource {
  @override
  Future<PaymentRequestEntity> create({
    required RequestMode mode,
    required double amountEtb,
    String? accountOrNote,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return PaymentRequestEntity(
      mode: mode,
      amountEtb: amountEtb,
      accountOrNote: accountOrNote,
      qrPayload: mode == RequestMode.qr
          ? 'CBE|REQ|${amountEtb.toStringAsFixed(2)}|MOCK'
          : null,
    );
  }
}
