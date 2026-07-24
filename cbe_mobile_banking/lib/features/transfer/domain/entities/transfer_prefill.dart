import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';
import 'package:equatable/equatable.dart';

/// Prefill values for Transfer form (from Scan QR or deep link).
class TransferPrefill extends Equatable {
  const TransferPrefill({
    this.rail,
    this.receiverName,
    this.destination,
    this.amountText,
  });

  final TransferRail? rail;
  final String? receiverName;
  final String? destination;
  final String? amountText;

  bool get isEmpty =>
      (receiverName == null || receiverName!.isEmpty) &&
      (destination == null || destination!.isEmpty) &&
      (amountText == null || amountText!.isEmpty);

  @override
  List<Object?> get props => [rail, receiverName, destination, amountText];
}

/// Parses mock CBE QR strings into [TransferPrefill].
///
/// Supported mock formats:
/// - `CBE|PAY|<destination>|<amount>`
/// - `CBE|REQ|<amount>|<note>`
/// - `CBE|BANK|<name>|<account>|<amount>`
/// - `CBE|WALLET|<name>|<account>|<amount>`
abstract final class PaymentQrParser {
  static TransferPrefill? tryParse(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;

    final parts = text.split('|');
    if (parts.length >= 2 && parts[0].toUpperCase() == 'CBE') {
      final kind = parts[1].toUpperCase();
      switch (kind) {
        case 'PAY':
          if (parts.length >= 4) {
            return TransferPrefill(
              rail: TransferRail.payment,
              receiverName: 'QR Payment',
              destination: parts[2],
              amountText: parts[3],
            );
          }
        case 'REQ':
          if (parts.length >= 3) {
            return TransferPrefill(
              rail: TransferRail.payment,
              receiverName: 'Payment request',
              destination: parts.length >= 4 ? parts[3] : 'QR-REQUEST',
              amountText: parts[2],
            );
          }
        case 'BANK':
          if (parts.length >= 5) {
            return TransferPrefill(
              rail: TransferRail.bank,
              receiverName: parts[2],
              destination: parts[3],
              amountText: parts[4],
            );
          }
        case 'WALLET':
          if (parts.length >= 5) {
            return TransferPrefill(
              rail: TransferRail.wallet,
              receiverName: parts[2],
              destination: parts[3],
              amountText: parts[4],
            );
          }
      }
    }

    // Opaque payload — keep as destination for manual review.
    return TransferPrefill(
      rail: TransferRail.payment,
      receiverName: 'Scanned QR',
      destination: text.length > 48 ? '${text.substring(0, 45)}…' : text,
    );
  }
}
