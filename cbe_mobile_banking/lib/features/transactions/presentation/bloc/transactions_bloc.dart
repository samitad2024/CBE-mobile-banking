import 'package:cbe_mobile_banking/features/transactions/domain/usecases/transactions_usecases.dart';
import 'package:cbe_mobile_banking/features/transactions/presentation/bloc/transactions_event.dart';
import 'package:cbe_mobile_banking/features/transactions/presentation/bloc/transactions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc({
    required this._getTransactions,
    required this._getReceipt,
  }) : super(const TransactionsInitial()) {
    on<TransactionsStarted>(_onStarted);
    on<TransactionsRefreshed>(_onRefreshed);
    on<TransactionSelected>(_onSelected);
    on<ReceiptDismissed>(_onDismissed);
  }

  final GetTransactionsUseCase _getTransactions;
  final GetReceiptUseCase _getReceipt;

  Future<void> _onStarted(
    TransactionsStarted event,
    Emitter<TransactionsState> emit,
  ) =>
      _load(emit);

  Future<void> _onRefreshed(
    TransactionsRefreshed event,
    Emitter<TransactionsState> emit,
  ) =>
      _load(emit);

  Future<void> _load(Emitter<TransactionsState> emit) async {
    emit(const TransactionsLoading());
    final result = await _getTransactions();
    if (result.failure != null) {
      emit(TransactionsFailureState(result.failure!.message));
      return;
    }
    emit(TransactionsLoaded(items: result.items!));
  }

  Future<void> _onSelected(
    TransactionSelected event,
    Emitter<TransactionsState> emit,
  ) async {
    final current = state;
    if (current is! TransactionsLoaded) return;
    final result = await _getReceipt(event.id);
    if (result.failure != null) {
      emit(TransactionsFailureState(result.failure!.message));
      return;
    }
    emit(current.copyWith(selectedReceipt: result.receipt));
  }

  void _onDismissed(ReceiptDismissed event, Emitter<TransactionsState> emit) {
    final current = state;
    if (current is TransactionsLoaded) {
      emit(current.copyWith(clearReceipt: true));
    }
  }
}
