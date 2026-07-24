import 'package:cbe_mobile_banking/features/transactions/domain/entities/transaction_entity.dart';
import 'package:equatable/equatable.dart';

sealed class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object?> get props => [];
}

final class TransactionsInitial extends TransactionsState {
  const TransactionsInitial();
}

final class TransactionsLoading extends TransactionsState {
  const TransactionsLoading();
}

final class TransactionsLoaded extends TransactionsState {
  const TransactionsLoaded({
    required this.items,
    this.selectedReceipt,
  });

  final List<TransactionEntity> items;
  final ReceiptEntity? selectedReceipt;

  TransactionsLoaded copyWith({
    List<TransactionEntity>? items,
    ReceiptEntity? selectedReceipt,
    bool clearReceipt = false,
  }) {
    return TransactionsLoaded(
      items: items ?? this.items,
      selectedReceipt:
          clearReceipt ? null : (selectedReceipt ?? this.selectedReceipt),
    );
  }

  @override
  List<Object?> get props => [items, selectedReceipt];
}

final class TransactionsFailureState extends TransactionsState {
  const TransactionsFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
