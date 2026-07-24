import 'package:cbe_mobile_banking/features/request_money/domain/entities/payment_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/usecases/create_payment_request_usecase.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/bloc/request_money_event.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/bloc/request_money_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestMoneyBloc extends Bloc<RequestMoneyEvent, RequestMoneyState> {
  RequestMoneyBloc({required this._createPaymentRequest})
      : super(const RequestMoneyFormState()) {
    on<RequestMoneyStarted>(_onStarted);
    on<RequestModeSelected>(_onMode);
    on<RequestAmountChanged>(_onAmount);
    on<RequestAccountChanged>(_onAccount);
    on<RequestSubmitted>(_onSubmit);
  }

  final CreatePaymentRequestUseCase _createPaymentRequest;

  void _onStarted(RequestMoneyStarted event, Emitter<RequestMoneyState> emit) {
    emit(const RequestMoneyFormState());
  }

  void _onMode(RequestModeSelected event, Emitter<RequestMoneyState> emit) {
    final form = state;
    if (form is! RequestMoneyFormState) return;
    emit(form.copyWith(mode: event.mode, clearValidation: true));
  }

  void _onAmount(RequestAmountChanged event, Emitter<RequestMoneyState> emit) {
    final form = state;
    if (form is! RequestMoneyFormState) return;
    emit(form.copyWith(amountText: event.value, clearValidation: true));
  }

  void _onAccount(
    RequestAccountChanged event,
    Emitter<RequestMoneyState> emit,
  ) {
    final form = state;
    if (form is! RequestMoneyFormState) return;
    emit(form.copyWith(accountText: event.value, clearValidation: true));
  }

  Future<void> _onSubmit(
    RequestSubmitted event,
    Emitter<RequestMoneyState> emit,
  ) async {
    final form = state;
    if (form is! RequestMoneyFormState) return;
    final amount = form.amountEtb;
    if (amount == null || amount <= 0) {
      emit(form.copyWith(validationMessage: 'Enter a valid amount'));
      return;
    }
    if (form.mode == RequestMode.account && form.accountText.trim().isEmpty) {
      emit(form.copyWith(validationMessage: 'Enter account details'));
      return;
    }
    emit(const RequestMoneySubmitting());
    final result = await _createPaymentRequest(
      mode: form.mode,
      amountEtb: amount,
      accountOrNote: form.accountText.trim().isEmpty
          ? null
          : form.accountText.trim(),
    );
    if (result.failure != null) {
      emit(RequestMoneyFailureState(result.failure!.message));
      return;
    }
    emit(RequestMoneySuccessState(result.request!));
  }
}
