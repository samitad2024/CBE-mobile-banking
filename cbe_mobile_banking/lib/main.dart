import 'package:cbe_mobile_banking/app/app.dart';
import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/core/bloc/app_bloc_observer.dart';
import 'package:cbe_mobile_banking/core/utils/app_logger.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await configureDependencies();
  sl<AuthSessionBloc>().add(const AuthSessionRestoreRequested());
  AppLogger.i('CBE Mobile Banking starting (BLoC + mock-first)');
  runApp(const CbeMobileBankingApp());
}
