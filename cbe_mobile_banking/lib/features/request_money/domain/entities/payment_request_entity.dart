import 'package:equatable/equatable.dart';

enum RequestMode { qr, account }

class PaymentRequestEntity extends Equatable {
  const PaymentRequestEntity({
    required this.mode,
    required this.amountEtb,
    this.accountOrNote,
    this.qrPayload,
  });

  final RequestMode mode;
  final double amountEtb;
  final String? accountOrNote;
  final String? qrPayload;

  @override
  List<Object?> get props => [mode, amountEtb, accountOrNote, qrPayload];
}
