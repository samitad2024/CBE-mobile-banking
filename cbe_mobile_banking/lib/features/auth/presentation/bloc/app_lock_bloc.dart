import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class AppLockEvent extends Equatable {
  const AppLockEvent();

  @override
  List<Object?> get props => [];
}

final class AppLockStarted extends AppLockEvent {
  const AppLockStarted();
}

final class AppLifecycleChanged extends AppLockEvent {
  const AppLifecycleChanged({required this.isResumed});

  final bool isResumed;

  @override
  List<Object?> get props => [isResumed];
}

final class AppUnlockRequested extends AppLockEvent {
  const AppUnlockRequested();
}

final class AppLockForced extends AppLockEvent {
  const AppLockForced();
}

sealed class AppLockState extends Equatable {
  const AppLockState();

  @override
  List<Object?> get props => [];
}

final class AppLockUnlocked extends AppLockState {
  const AppLockUnlocked();
}

final class AppLockLocked extends AppLockState {
  const AppLockLocked();
}

/// Locks the app after backgrounding (idle policy refined in Step 11).
class AppLockBloc extends Bloc<AppLockEvent, AppLockState> {
  AppLockBloc() : super(const AppLockUnlocked()) {
    on<AppLockStarted>((event, emit) => emit(const AppLockUnlocked()));
    on<AppLifecycleChanged>(_onLifecycle);
    on<AppUnlockRequested>((event, emit) => emit(const AppLockUnlocked()));
    on<AppLockForced>((event, emit) => emit(const AppLockLocked()));
  }

  void _onLifecycle(
    AppLifecycleChanged event,
    Emitter<AppLockState> emit,
  ) {
    if (!event.isResumed) {
      emit(const AppLockLocked());
    }
  }
}
