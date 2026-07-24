import 'package:equatable/equatable.dart';

sealed class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object?> get props => [];
}

final class TransactionsStarted extends TransactionsEvent {
  const TransactionsStarted();
}

final class TransactionSelected extends TransactionsEvent {
  const TransactionSelected(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class ReceiptDismissed extends TransactionsEvent {
  const ReceiptDismissed();
}
