import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';
import 'package:equatable/equatable.dart';

sealed class TransferState extends Equatable {
  const TransferState();

  @override
  List<Object?> get props => [];
}

final class TransferFormState extends TransferState {
  const TransferFormState({
    this.rail = TransferRail.bank,
    this.receiverName = '',
    this.destination = '',
    this.amountText = '',
    this.validationMessage,
  });

  final TransferRail rail;
  final String receiverName;
  final String destination;
  final String amountText;
  final String? validationMessage;

  double? get amountEtb => double.tryParse(amountText.replaceAll(',', ''));

  TransferFormState copyWith({
    TransferRail? rail,
    String? receiverName,
    String? destination,
    String? amountText,
    String? validationMessage,
    bool clearValidation = false,
  }) {
    return TransferFormState(
      rail: rail ?? this.rail,
      receiverName: receiverName ?? this.receiverName,
      destination: destination ?? this.destination,
      amountText: amountText ?? this.amountText,
      validationMessage: clearValidation
          ? null
          : (validationMessage ?? this.validationMessage),
    );
  }

  @override
  List<Object?> get props =>
      [rail, receiverName, destination, amountText, validationMessage];
}

final class TransferConfirmState extends TransferState {
  const TransferConfirmState(this.draft);

  final TransferDraftEntity draft;

  @override
  List<Object?> get props => [draft];
}

final class TransferSubmitting extends TransferState {
  const TransferSubmitting(this.draft);

  final TransferDraftEntity draft;

  @override
  List<Object?> get props => [draft];
}

final class TransferSuccessState extends TransferState {
  const TransferSuccessState(this.result);

  final TransferResultEntity result;

  @override
  List<Object?> get props => [result];
}

final class TransferFailureState extends TransferState {
  const TransferFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
