import 'package:equatable/equatable.dart';

enum TransactionDirection { credit, debit }

class TransactionEntity extends Equatable {
  const TransactionEntity({
    required this.id,
    required this.title,
    required this.amountEtb,
    required this.direction,
    required this.occurredAt,
    this.partnerLabel,
  });

  final String id;
  final String title;
  final double amountEtb;
  final TransactionDirection direction;
  final DateTime occurredAt;
  final String? partnerLabel;

  @override
  List<Object?> get props =>
      [id, title, amountEtb, direction, occurredAt, partnerLabel];
}

class ReceiptEntity extends Equatable {
  const ReceiptEntity({
    required this.transactionNumber,
    required this.amountEtb,
    required this.receiverName,
    required this.receiverNumber,
  });

  final String transactionNumber;
  final double amountEtb;
  final String receiverName;
  final String receiverNumber;

  @override
  List<Object?> get props =>
      [transactionNumber, amountEtb, receiverName, receiverNumber];
}
