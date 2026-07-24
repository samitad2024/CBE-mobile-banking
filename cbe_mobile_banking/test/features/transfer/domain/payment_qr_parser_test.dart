import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_prefill.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses CBE|PAY mock payload', () {
    final prefill = PaymentQrParser.tryParse('CBE|PAY|MOCK|50000');
    expect(prefill, isNotNull);
    expect(prefill!.rail, TransferRail.payment);
    expect(prefill.destination, 'MOCK');
    expect(prefill.amountText, '50000');
  });

  test('parses CBE|BANK payload', () {
    final prefill =
        PaymentQrParser.tryParse('CBE|BANK|Ada|1000582007601|2500');
    expect(prefill!.rail, TransferRail.bank);
    expect(prefill.receiverName, 'Ada');
    expect(prefill.destination, '1000582007601');
    expect(prefill.amountText, '2500');
  });

  test('opaque payload becomes payment destination', () {
    final prefill = PaymentQrParser.tryParse('random-qr-value');
    expect(prefill!.rail, TransferRail.payment);
    expect(prefill.destination, 'random-qr-value');
  });
}
