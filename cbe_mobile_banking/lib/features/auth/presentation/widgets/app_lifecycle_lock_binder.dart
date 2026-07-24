import 'dart:async';

import 'package:cbe_mobile_banking/core/constants/app_constants.dart';
import 'package:cbe_mobile_banking/core/security/biometric_gateway.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/core/widgets/app_secondary_button.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/app_lock_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_event.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Forwards lifecycle + interaction idle checks to [AppLockBloc].
class AppLifecycleLockBinder extends StatefulWidget {
  const AppLifecycleLockBinder({
    required this.child,
    required this.biometricGateway,
    super.key,
  });

  final Widget child;
  final BiometricGateway biometricGateway;

  @override
  State<AppLifecycleLockBinder> createState() => _AppLifecycleLockBinderState();
}

class _AppLifecycleLockBinderState extends State<AppLifecycleLockBinder>
    with WidgetsBindingObserver {
  Timer? _idleTicker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _idleTicker = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final lock = context.read<AppLockBloc>();
      final session = context.read<AuthSessionBloc>().state;
      if (session is! AuthSessionAuthenticated) return;
      if (lock.state is AppLockLocked) return;
      if (lock.isIdleExpired) {
        lock.add(const AppLockForced());
      }
    });
  }

  @override
  void dispose() {
    _idleTicker?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final resumed = state == AppLifecycleState.resumed;
    context.read<AppLockBloc>().add(AppLifecycleChanged(isResumed: resumed));
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        context.read<AppLockBloc>().add(const AppUserInteractionDetected());
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          BlocBuilder<AuthSessionBloc, AuthSessionState>(
            builder: (context, session) {
              if (session is! AuthSessionAuthenticated) {
                return const SizedBox.shrink();
              }
              return BlocBuilder<AppLockBloc, AppLockState>(
                builder: (context, lock) {
                  if (lock is! AppLockLocked &&
                      lock is! AppLockBiometricInProgress) {
                    return const SizedBox.shrink();
                  }
                  return _AppLockOverlay(
                    biometricGateway: widget.biometricGateway,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AppLockOverlay extends StatefulWidget {
  const _AppLockOverlay({required this.biometricGateway});

  final BiometricGateway biometricGateway;

  @override
  State<_AppLockOverlay> createState() => _AppLockOverlayState();
}

class _AppLockOverlayState extends State<_AppLockOverlay> {
  bool _busy = false;
  String? _error;

  Future<void> _unlock() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await widget.biometricGateway.authenticate(
      reason: 'Unlock CBE Mobile Banking',
    );
    if (!mounted) return;
    if (ok) {
      context.read<AppLockBloc>().add(const AppUnlockRequested());
    } else {
      setState(() {
        _busy = false;
        _error = 'Biometric unlock failed. Try again or sign out.';
      });
      return;
    }
    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.plumDeep.withValues(alpha: 0.97),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.lock_outline, color: AppColors.peach, size: 56),
              const SizedBox(height: 16),
              Text(
                'App Locked',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Session paused after ${AppConstants.appLockIdleTimeout.inSeconds}s idle. '
                'Unlock with biometrics to continue.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.debit),
                ),
              ],
              const Spacer(),
              AppPrimaryButton(
                label: _busy ? 'Unlocking…' : 'Unlock',
                icon: Icons.fingerprint,
                onPressed: _busy ? null : _unlock,
              ),
              const SizedBox(height: 12),
              AppSecondaryButton(
                label: 'Sign out',
                onPressed: _busy
                    ? null
                    : () {
                        context
                            .read<AuthSessionBloc>()
                            .add(const AuthSessionLoggedOut());
                        context
                            .read<AppLockBloc>()
                            .add(const AppUnlockRequested());
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
