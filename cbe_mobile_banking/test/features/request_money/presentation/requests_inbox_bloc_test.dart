import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/incoming_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/payment_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/repositories/request_money_repository.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/usecases/get_pending_requests_usecase.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/bloc/requests_inbox_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements RequestMoneyRepository {
  @override
  Future<({Failure? failure, PaymentRequestEntity? request})> createRequest({
    required RequestMode mode,
    required double amountEtb,
    String? accountOrNote,
  }) async {
    return (failure: null, request: null);
  }

  @override
  Future<({Failure? failure, List<IncomingRequestEntity>? items})>
      getPendingRequests() async {
    return (
      failure: null,
      items: [
        IncomingRequestEntity(
          id: '1',
          fromName: 'Ada',
          maskedAccount: '1000 ******** 1234',
          amountEtb: 100,
          note: 'Test',
          requestedAt: DateTime(2024),
        ),
      ],
    );
  }
}

void main() {
  test('loads pending requests', () async {
    final bloc = RequestsInboxBloc(
      getPendingRequests: GetPendingRequestsUseCase(_FakeRepo()),
    )..add(const RequestsInboxStarted());
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(bloc.state, isA<RequestsInboxLoaded>());
    expect((bloc.state as RequestsInboxLoaded).items, hasLength(1));
    await bloc.close();
  });
}
