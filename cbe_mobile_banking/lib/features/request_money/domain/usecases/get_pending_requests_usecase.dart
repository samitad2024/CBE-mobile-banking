import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/incoming_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/repositories/request_money_repository.dart';

class GetPendingRequestsUseCase {
  GetPendingRequestsUseCase(this._repository);

  final RequestMoneyRepository _repository;

  Future<({Failure? failure, List<IncomingRequestEntity>? items})> call() {
    return _repository.getPendingRequests();
  }
}
