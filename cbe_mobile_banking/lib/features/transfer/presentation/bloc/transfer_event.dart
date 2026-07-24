import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_prefill.dart';
import 'package:equatable/equatable.dart';

sealed class TransferEvent extends Equatable {
  const TransferEvent();

  @override
  List<Object?> get props => [];
}

final class TransferStarted extends TransferEvent {
  const TransferStarted({this.prefill});

  final TransferPrefill? prefill;

  @override
  List<Object?> get props => [prefill];
}

final class TransferRailSelected extends TransferEvent {
  const TransferRailSelected(this.rail);

  final TransferRail rail;

  @override
  List<Object?> get props => [rail];
}

final class TransferReceiverChanged extends TransferEvent {
  const TransferReceiverChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class TransferDestinationChanged extends TransferEvent {
  const TransferDestinationChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class TransferAmountChanged extends TransferEvent {
  const TransferAmountChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class TransferReviewRequested extends TransferEvent {
  const TransferReviewRequested();
}

final class TransferConfirmed extends TransferEvent {
  const TransferConfirmed({required this.idempotencyKey});

  final String idempotencyKey;

  @override
  List<Object?> get props => [idempotencyKey];
}

final class TransferRetried extends TransferEvent {
  const TransferRetried({required this.idempotencyKey});

  final String idempotencyKey;

  @override
  List<Object?> get props => [idempotencyKey];
}

final class TransferConfirmDismissed extends TransferEvent {
  const TransferConfirmDismissed();
}

final class TransferReset extends TransferEvent {
  const TransferReset();
}
