import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class ScanEvent extends Equatable {
  const ScanEvent();

  @override
  List<Object?> get props => [];
}

final class ScanStarted extends ScanEvent {
  const ScanStarted();
}

final class ScanMockCodeDetected extends ScanEvent {
  const ScanMockCodeDetected(this.payload);

  final String payload;

  @override
  List<Object?> get props => [payload];
}

final class ScanReset extends ScanEvent {
  const ScanReset();
}

sealed class ScanState extends Equatable {
  const ScanState();

  @override
  List<Object?> get props => [];
}

final class ScanIdle extends ScanState {
  const ScanIdle();
}

final class ScanListening extends ScanState {
  const ScanListening();
}

final class ScanSuccess extends ScanState {
  const ScanSuccess(this.payload);

  final String payload;

  @override
  List<Object?> get props => [payload];
}

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(const ScanIdle()) {
    on<ScanStarted>((event, emit) => emit(const ScanListening()));
    on<ScanMockCodeDetected>(
      (event, emit) => emit(ScanSuccess(event.payload)),
    );
    on<ScanReset>((event, emit) => emit(const ScanIdle()));
  }
}
