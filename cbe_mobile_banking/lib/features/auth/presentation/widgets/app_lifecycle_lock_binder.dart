import 'package:cbe_mobile_banking/features/auth/presentation/bloc/app_lock_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Forwards app lifecycle to [AppLockBloc] (blueprint Step 11).
class AppLifecycleLockBinder extends StatefulWidget {
  const AppLifecycleLockBinder({required this.child, super.key});

  final Widget child;

  @override
  State<AppLifecycleLockBinder> createState() => _AppLifecycleLockBinderState();
}

class _AppLifecycleLockBinderState extends State<AppLifecycleLockBinder>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final resumed = state == AppLifecycleState.resumed;
    context.read<AppLockBloc>().add(AppLifecycleChanged(isResumed: resumed));
    if (resumed) {
      context.read<AppLockBloc>().add(const AppUnlockRequested());
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
