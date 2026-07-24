import 'package:cbe_mobile_banking/features/request_money/domain/entities/incoming_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/payment_request_entity.dart';

/// Request-money data contract — mock and remote share this interface.
abstract interface class RequestMoneyDataSource {
  Future<PaymentRequestEntity> create({
    required RequestMode mode,
    required double amountEtb,
    String? accountOrNote,
  });

  Future<List<IncomingRequestEntity>> fetchPendingRequests();
}

class RequestMoneyMockDataSourceImpl implements RequestMoneyDataSource {
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

  @override
  Future<List<IncomingRequestEntity>> fetchPendingRequests() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return [
      IncomingRequestEntity(
        id: 'r1',
        fromName: 'Mamo Muluken Gebeye',
        maskedAccount: '1000 ******** 8821',
        amountEtb: 5000,
        note: 'Lunch split',
        requestedAt: DateTime(2024, 12, 24, 10, 15),
      ),
      IncomingRequestEntity(
        id: 'r2',
        fromName: 'Hiwet Amha Sileshi',
        maskedAccount: '0930 **** 8495',
        amountEtb: 1200,
        note: 'Taxi fare',
        requestedAt: DateTime(2024, 12, 23, 18, 40),
      ),
      IncomingRequestEntity(
        id: 'r3',
        fromName: 'Ahmed Abdella Yesuf',
        maskedAccount: '1000 ******** 5744',
        amountEtb: 25000,
        note: 'House contribution',
        requestedAt: DateTime(2024, 12, 22, 9, 5),
      ),
    ];
  }
}
