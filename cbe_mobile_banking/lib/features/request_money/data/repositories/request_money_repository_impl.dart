import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/request_money/data/datasources/request_money_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/payment_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/repositories/request_money_repository.dart';

class RequestMoneyRepositoryImpl implements RequestMoneyRepository {
  RequestMoneyRepositoryImpl({
    required this._mockDataSource,
  });

  final RequestMoneyMockDataSource _mockDataSource;

  @override
  Future<({Failure? failure, PaymentRequestEntity? request})> createRequest({
    required RequestMode mode,
    required double amountEtb,
    String? accountOrNote,
  }) async {
    try {
      final request = await _mockDataSource.create(
        mode: mode,
        amountEtb: amountEtb,
        accountOrNote: accountOrNote,
      );
      return (failure: null, request: request);
    } on Exception {
      return (failure: const UnexpectedFailure(), request: null);
    }
  }
}
