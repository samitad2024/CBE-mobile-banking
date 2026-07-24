import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/app/router/app_router.dart';
import 'package:cbe_mobile_banking/core/theme/app_theme.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/app_lock_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Root application widget with app-scoped Blocs.
class CbeMobileBankingApp extends StatelessWidget {
  const CbeMobileBankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthSessionBloc>.value(value: sl<AuthSessionBloc>()),
        BlocProvider<AppLockBloc>.value(
          value: sl<AppLockBloc>()..add(const AppLockStarted()),
        ),
      ],
      child: MaterialApp.router(
        title: 'CBE Mobile Banking',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: AppRouter.createRouter(sl<AuthSessionBloc>()),
      ),
    );
  }
}
