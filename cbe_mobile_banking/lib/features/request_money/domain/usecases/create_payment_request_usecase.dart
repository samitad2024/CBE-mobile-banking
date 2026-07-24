import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/payment_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/repositories/request_money_repository.dart';

class CreatePaymentRequestUseCase {
  CreatePaymentRequestUseCase(this._repository);

  final RequestMoneyRepository _repository;

  Future<({Failure? failure, PaymentRequestEntity? request})> call({
    required RequestMode mode,
    required double amountEtb,
    String? accountOrNote,
  }) {
    if (amountEtb <= 0) {
      return Future.value(
        (failure: const ValidationFailure('Enter a valid amount'), request: null),
      );
    }
    return _repository.createRequest(
      mode: mode,
      amountEtb: amountEtb,
      accountOrNote: accountOrNote,
    );
  }
}
