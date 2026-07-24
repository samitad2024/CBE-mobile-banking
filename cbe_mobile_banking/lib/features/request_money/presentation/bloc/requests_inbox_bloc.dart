import 'package:cbe_mobile_banking/features/request_money/domain/entities/incoming_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/usecases/get_pending_requests_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class RequestsInboxEvent extends Equatable {
  const RequestsInboxEvent();

  @override
  List<Object?> get props => [];
}

final class RequestsInboxStarted extends RequestsInboxEvent {
  const RequestsInboxStarted();
}

final class RequestsInboxRefreshed extends RequestsInboxEvent {
  const RequestsInboxRefreshed();
}

sealed class RequestsInboxState extends Equatable {
  const RequestsInboxState();

  @override
  List<Object?> get props => [];
}

final class RequestsInboxInitial extends RequestsInboxState {
  const RequestsInboxInitial();
}

final class RequestsInboxLoading extends RequestsInboxState {
  const RequestsInboxLoading();
}

final class RequestsInboxLoaded extends RequestsInboxState {
  const RequestsInboxLoaded(this.items);

  final List<IncomingRequestEntity> items;

  @override
  List<Object?> get props => [items];
}

final class RequestsInboxFailure extends RequestsInboxState {
  const RequestsInboxFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class RequestsInboxBloc extends Bloc<RequestsInboxEvent, RequestsInboxState> {
  RequestsInboxBloc({required this.getPendingRequests})
      : super(const RequestsInboxInitial()) {
    on<RequestsInboxStarted>(_onLoad);
    on<RequestsInboxRefreshed>(_onLoad);
  }

  final GetPendingRequestsUseCase getPendingRequests;

  Future<void> _onLoad(
    RequestsInboxEvent event,
    Emitter<RequestsInboxState> emit,
  ) async {
    emit(const RequestsInboxLoading());
    final result = await getPendingRequests();
    if (result.failure != null) {
      emit(RequestsInboxFailure(result.failure!.message));
      return;
    }
    emit(RequestsInboxLoaded(result.items ?? const []));
  }
}
