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
    on<TransferConfirmed>(_onConfirm);
    on<TransferReset>(_onReset);
  }

  final SubmitTransferUseCase _submitTransfer;

  void _onStarted(TransferStarted event, Emitter<TransferState> emit) {
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
    emit(
      TransferConfirmState(
        TransferDraftEntity(
          rail: form.rail,
          receiverName: form.receiverName.trim(),
          destination: form.destination.trim(),
          amountEtb: amount,
        ),
      ),
    );
  }

  Future<void> _onConfirm(
    TransferConfirmed event,
    Emitter<TransferState> emit,
  ) async {
    final confirm = state;
    if (confirm is! TransferConfirmState) return;
    emit(TransferSubmitting(confirm.draft));
    final result = await _submitTransfer(confirm.draft);
    if (result.failure != null) {
      emit(TransferFailureState(result.failure!.message));
      return;
    }
    emit(TransferSuccessState(result.result!));
  }

  void _onReset(TransferReset event, Emitter<TransferState> emit) {
    emit(const TransferFormState());
  }

  TransferFormState? _asForm(TransferState state) {
    return state is TransferFormState ? state : null;
  }
}
