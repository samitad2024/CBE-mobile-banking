import 'package:cbe_mobile_banking/features/request_money/domain/entities/payment_request_entity.dart';
import 'package:equatable/equatable.dart';

sealed class RequestMoneyEvent extends Equatable {
  const RequestMoneyEvent();

  @override
  List<Object?> get props => [];
}

final class RequestMoneyStarted extends RequestMoneyEvent {
  const RequestMoneyStarted();
}

final class RequestModeSelected extends RequestMoneyEvent {
  const RequestModeSelected(this.mode);

  final RequestMode mode;

  @override
  List<Object?> get props => [mode];
}

final class RequestAmountChanged extends RequestMoneyEvent {
  const RequestAmountChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class RequestAccountChanged extends RequestMoneyEvent {
  const RequestAccountChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class RequestSubmitted extends RequestMoneyEvent {
  const RequestSubmitted();
}
