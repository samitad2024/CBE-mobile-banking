import 'package:equatable/equatable.dart';

/// Incoming money request shown in the Home "Requests" inbox.
class IncomingRequestEntity extends Equatable {
  const IncomingRequestEntity({
    required this.id,
    required this.fromName,
    required this.maskedAccount,
    required this.amountEtb,
    required this.note,
    required this.requestedAt,
  });

  final String id;
  final String fromName;
  final String maskedAccount;
  final double amountEtb;
  final String note;
  final DateTime requestedAt;

  @override
  List<Object?> get props =>
      [id, fromName, maskedAccount, amountEtb, note, requestedAt];
}
