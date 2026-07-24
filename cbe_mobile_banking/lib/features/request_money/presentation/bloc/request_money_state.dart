import 'package:cbe_mobile_banking/features/request_money/domain/entities/payment_request_entity.dart';
import 'package:equatable/equatable.dart';

sealed class RequestMoneyState extends Equatable {
  const RequestMoneyState();

  @override
  List<Object?> get props => [];
}

final class RequestMoneyFormState extends RequestMoneyState {
  const RequestMoneyFormState({
    this.mode = RequestMode.qr,
    this.amountText = '',
    this.accountText = '',
    this.validationMessage,
  });

  final RequestMode mode;
  final String amountText;
  final String accountText;
  final String? validationMessage;

  double? get amountEtb => double.tryParse(amountText.replaceAll(',', ''));

  RequestMoneyFormState copyWith({
    RequestMode? mode,
    String? amountText,
    String? accountText,
    String? validationMessage,
    bool clearValidation = false,
  }) {
    return RequestMoneyFormState(
      mode: mode ?? this.mode,
      amountText: amountText ?? this.amountText,
      accountText: accountText ?? this.accountText,
      validationMessage: clearValidation
          ? null
          : (validationMessage ?? this.validationMessage),
    );
  }

  @override
  List<Object?> get props =>
      [mode, amountText, accountText, validationMessage];
}

final class RequestMoneySubmitting extends RequestMoneyState {
  const RequestMoneySubmitting();
}

final class RequestMoneySuccessState extends RequestMoneyState {
  const RequestMoneySuccessState(this.request);

  final PaymentRequestEntity request;

  @override
  List<Object?> get props => [request];
}

final class RequestMoneyFailureState extends RequestMoneyState {
  const RequestMoneyFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
