import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/usecases/submit_transfer_usecase.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/bloc/transfer_event.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/bloc/transfer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  TransferBloc({required this._submitTransfer})
      : super(const TransferFormState()) {
    on<TransferStarted>(_onStarted);
    on<TransferRailSelected>(_onRailSelected);
    on<TransferReceiverChanged>(_onReceiverChanged);
    on<TransferDestinationChanged>(_onDestinationChanged);
    on<TransferAmountChanged>(_onAmountChanged);
    on<TransferReviewRequested>(_onReview);
    on<TransferConfirmed>(_onConfirm, transformer: droppable());
    on<TransferRetried>(_onRetry, transformer: droppable());
    on<TransferConfirmDismissed>(_onConfirmDismissed);
    on<TransferReset>(_onReset);
  }

  final SubmitTransferUseCase _submitTransfer;
  final Set<String> _processedKeys = <String>{};
  TransferDraftEntity? _lastDraft;

  void _onStarted(TransferStarted event, Emitter<TransferState> emit) {
    _processedKeys.clear();
    _lastDraft = null;
    emit(const TransferFormState());
  }

  void _onRailSelected(
    TransferRailSelected event,
    Emitter<TransferState> emit,
  ) {
    final form = _asForm(state);
    if (form == null) return;
    emit(form.copyWith(rail: event.rail, clearValidation: true));
  }

  void _onReceiverChanged(
    TransferReceiverChanged event,
    Emitter<TransferState> emit,
  ) {
    final form = _asForm(state);
    if (form == null) return;
    emit(form.copyWith(receiverName: event.value, clearValidation: true));
  }

  void _onDestinationChanged(
    TransferDestinationChanged event,
    Emitter<TransferState> emit,
  ) {
    final form = _asForm(state);
    if (form == null) return;
    emit(form.copyWith(destination: event.value, clearValidation: true));
  }

  void _onAmountChanged(
    TransferAmountChanged event,
    Emitter<TransferState> emit,
  ) {
    final form = _asForm(state);
    if (form == null) return;
    emit(form.copyWith(amountText: event.value, clearValidation: true));
  }

  void _onReview(
    TransferReviewRequested event,
    Emitter<TransferState> emit,
  ) {
    final form = _asForm(state);
    if (form == null) return;
    final amount = form.amountEtb;
    if (form.receiverName.trim().isEmpty ||
        form.destination.trim().isEmpty ||
        amount == null ||
        amount <= 0) {
      emit(
        form.copyWith(
          validationMessage: 'Enter receiver, destination, and a valid amount',
        ),
      );
      return;
    }
    final draft = TransferDraftEntity(
      rail: form.rail,
      receiverName: form.receiverName.trim(),
      destination: form.destination.trim(),
      amountEtb: amount,
    );
    _lastDraft = draft;
    emit(TransferConfirmState(draft));
  }

  Future<void> _onConfirm(
    TransferConfirmed event,
    Emitter<TransferState> emit,
  ) async {
    if (_processedKeys.contains(event.idempotencyKey)) {
      return;
    }
    final confirm = state;
    if (confirm is! TransferConfirmState) return;
    await _submit(confirm.draft, event.idempotencyKey, emit);
  }

  Future<void> _onRetry(
    TransferRetried event,
    Emitter<TransferState> emit,
  ) async {
    final draft = _lastDraft;
    if (draft == null) return;
    if (_processedKeys.contains(event.idempotencyKey)) return;
    emit(TransferConfirmState(draft));
    await _submit(draft, event.idempotencyKey, emit);
  }

  Future<void> _submit(
    TransferDraftEntity draft,
    String key,
    Emitter<TransferState> emit,
  ) async {
    emit(TransferSubmitting(draft));
    final result = await _submitTransfer(draft);
    if (result.failure != null) {
      emit(TransferFailureState(result.failure!.message));
      emit(TransferConfirmState(draft));
      return;
    }
    _processedKeys.add(key);
    emit(TransferSuccessState(result.result!));
  }

  void _onConfirmDismissed(
    TransferConfirmDismissed event,
    Emitter<TransferState> emit,
  ) {
    final confirm = state;
    if (confirm is! TransferConfirmState) return;
    final d = confirm.draft;
    emit(
      TransferFormState(
        rail: d.rail,
        receiverName: d.receiverName,
        destination: d.destination,
        amountText: d.amountEtb.toStringAsFixed(2),
      ),
    );
  }

  void _onReset(TransferReset event, Emitter<TransferState> emit) {
    emit(const TransferFormState());
  }

  TransferFormState? _asForm(TransferState state) {
    return state is TransferFormState ? state : null;
  }
}
