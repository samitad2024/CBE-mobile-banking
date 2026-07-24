import 'package:equatable/equatable.dart';

enum TransferRail { payment, bank, wallet }

class TransferDraftEntity extends Equatable {
  const TransferDraftEntity({
    required this.rail,
    required this.receiverName,
    required this.destination,
    required this.amountEtb,
  });

  final TransferRail rail;
  final String receiverName;
  final String destination;
  final double amountEtb;

  @override
  List<Object?> get props => [rail, receiverName, destination, amountEtb];
}

class TransferResultEntity extends Equatable {
  const TransferResultEntity({
    required this.transactionId,
    required this.amountEtb,
    required this.receiverName,
    required this.destination,
    required this.message,
  });

  final String transactionId;
  final double amountEtb;
  final String receiverName;
  final String destination;
  final String message;

  @override
  List<Object?> get props =>
      [transactionId, amountEtb, receiverName, destination, message];
}
