import 'package:cbe_mobile_banking/core/error/exceptions.dart';
import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/request_money/data/datasources/request_money_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/incoming_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/payment_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/repositories/request_money_repository.dart';

class RequestMoneyRepositoryImpl implements RequestMoneyRepository {
  RequestMoneyRepositoryImpl({required this._dataSource});

  final RequestMoneyDataSource _dataSource;

  @override
  Future<({Failure? failure, PaymentRequestEntity? request})> createRequest({
    required RequestMode mode,
    required double amountEtb,
    String? accountOrNote,
  }) async {
    try {
      final request = await _dataSource.create(
        mode: mode,
        amountEtb: amountEtb,
        accountOrNote: accountOrNote,
      );
      return (failure: null, request: request);
    } on NetworkException catch (e) {
      return (failure: NetworkFailure(e.message), request: null);
    } on ServerException catch (e) {
      return (failure: ServerFailure(e.message), request: null);
    } on AuthException catch (e) {
      return (failure: AuthFailure(e.message), request: null);
    } on Exception {
      return (failure: const UnexpectedFailure(), request: null);
    }
  }

  @override
  Future<({Failure? failure, List<IncomingRequestEntity>? items})>
      getPendingRequests() async {
    try {
      final items = await _dataSource.fetchPendingRequests();
      return (failure: null, items: items);
    } on NetworkException catch (e) {
      return (failure: NetworkFailure(e.message), items: null);
    } on ServerException catch (e) {
      return (failure: ServerFailure(e.message), items: null);
    } on AuthException catch (e) {
      return (failure: AuthFailure(e.message), items: null);
    } on Exception {
      return (failure: const UnexpectedFailure(), items: null);
    }
  }
}
