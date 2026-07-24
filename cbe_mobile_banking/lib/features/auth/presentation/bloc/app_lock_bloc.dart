import 'package:cbe_mobile_banking/core/constants/app_constants.dart';
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

final class AppUserInteractionDetected extends AppLockEvent {
  const AppUserInteractionDetected();
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

final class AppLockBiometricInProgress extends AppLockState {
  const AppLockBiometricInProgress();
}

/// Locks after background idle timeout or forced lock (blueprint Step 11).
class AppLockBloc extends Bloc<AppLockEvent, AppLockState> {
  AppLockBloc({
    DateTime Function()? clock,
    Duration? idleTimeout,
  })  : _clock = clock ?? DateTime.now,
        _idleTimeout = idleTimeout ?? AppConstants.appLockIdleTimeout,
        super(const AppLockUnlocked()) {
    on<AppLockStarted>(_onStarted);
    on<AppLifecycleChanged>(_onLifecycle);
    on<AppUserInteractionDetected>(_onInteraction);
    on<AppUnlockRequested>(_onUnlock);
    on<AppLockForced>((event, emit) => emit(const AppLockLocked()));
  }

  final DateTime Function() _clock;
  final Duration _idleTimeout;
  DateTime? _pausedAt;
  DateTime _lastInteraction = DateTime.now();

  void _onStarted(AppLockStarted event, Emitter<AppLockState> emit) {
    _pausedAt = null;
    _lastInteraction = _clock();
    emit(const AppLockUnlocked());
  }

  void _onLifecycle(
    AppLifecycleChanged event,
    Emitter<AppLockState> emit,
  ) {
    if (!event.isResumed) {
      _pausedAt = _clock();
      return;
    }

    final paused = _pausedAt;
    _pausedAt = null;
    if (paused == null) return;

    final away = _clock().difference(paused);
    if (away >= _idleTimeout) {
      emit(const AppLockLocked());
      return;
    }

    // Also lock if foreground idle already exceeded before pause.
    if (_clock().difference(_lastInteraction) >= _idleTimeout) {
      emit(const AppLockLocked());
    }
  }

  void _onInteraction(
    AppUserInteractionDetected event,
    Emitter<AppLockState> emit,
  ) {
    _lastInteraction = _clock();
    if (state is AppLockUnlocked) return;
    // Interactions while locked do not unlock — biometric required.
  }

  void _onUnlock(AppUnlockRequested event, Emitter<AppLockState> emit) {
    _lastInteraction = _clock();
    emit(const AppLockUnlocked());
  }

  /// Exposed for idle watcher (foreground timeout check).
  bool get isIdleExpired =>
      _clock().difference(_lastInteraction) >= _idleTimeout;
}
