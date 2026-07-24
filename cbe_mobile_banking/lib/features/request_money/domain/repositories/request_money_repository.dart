import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/incoming_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/payment_request_entity.dart';

abstract interface class RequestMoneyRepository {
  Future<({Failure? failure, PaymentRequestEntity? request})> createRequest({
    required RequestMode mode,
    required double amountEtb,
    String? accountOrNote,
  });

  Future<({Failure? failure, List<IncomingRequestEntity>? items})>
      getPendingRequests();
}
