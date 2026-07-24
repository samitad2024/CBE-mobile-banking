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

/// Fired for both camera detections and the mock simulate button.
final class ScanCodeDetected extends ScanEvent {
  const ScanCodeDetected(this.payload);

  final String payload;

  @override
  List<Object?> get props => [payload];
}

final class ScanFailed extends ScanEvent {
  const ScanFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
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

final class ScanFailure extends ScanState {
  const ScanFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(const ScanIdle()) {
    on<ScanStarted>((event, emit) => emit(const ScanListening()));
    on<ScanCodeDetected>(_onCodeDetected);
    on<ScanFailed>((event, emit) => emit(ScanFailure(event.message)));
    on<ScanReset>((event, emit) => emit(const ScanIdle()));
  }

  void _onCodeDetected(ScanCodeDetected event, Emitter<ScanState> emit) {
    if (state is ScanSuccess) return;
    final payload = event.payload.trim();
    if (payload.isEmpty) return;
    // Never put full payment payloads into logs — state carries for UI only.
    emit(ScanSuccess(payload));
  }
}
