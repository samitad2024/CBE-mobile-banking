import 'package:cbe_mobile_banking/features/auth/presentation/bloc/app_lock_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('background shorter than idle keeps unlocked on resume', () async {
    var now = DateTime(2026, 1, 1, 12);
    final bloc = AppLockBloc(
      clock: () => now,
      idleTimeout: const Duration(seconds: 45),
    )..add(const AppLockStarted());
    await Future<void>.delayed(Duration.zero);

    bloc.add(const AppLifecycleChanged(isResumed: false));
    now = now.add(const Duration(seconds: 10));
    bloc.add(const AppLifecycleChanged(isResumed: true));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state, isA<AppLockUnlocked>());
    await bloc.close();
  });

  test('background past idle timeout locks on resume', () async {
    var now = DateTime(2026, 1, 1, 12);
    final bloc = AppLockBloc(
      clock: () => now,
      idleTimeout: const Duration(seconds: 45),
    )..add(const AppLockStarted());
    await Future<void>.delayed(Duration.zero);

    bloc.add(const AppLifecycleChanged(isResumed: false));
    now = now.add(const Duration(seconds: 46));
    bloc.add(const AppLifecycleChanged(isResumed: true));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state, isA<AppLockLocked>());
    await bloc.close();
  });

  test('unlock clears lock after idle', () async {
    var now = DateTime(2026, 1, 1, 12);
    final bloc = AppLockBloc(
      clock: () => now,
      idleTimeout: const Duration(seconds: 45),
    )..add(const AppLockStarted());
    await Future<void>.delayed(Duration.zero);

    bloc.add(const AppLifecycleChanged(isResumed: false));
    now = now.add(const Duration(seconds: 60));
    bloc.add(const AppLifecycleChanged(isResumed: true));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state, isA<AppLockLocked>());

    bloc.add(const AppUnlockRequested());
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state, isA<AppLockUnlocked>());
    await bloc.close();
  });
}
