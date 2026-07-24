import 'package:cbe_mobile_banking/core/utils/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Global BLoC observer — logs transitions without secrets (no PIN/token/PII).
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    AppLogger.d('BLoC create: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    AppLogger.d(
      '${bloc.runtimeType} ${change.currentState.runtimeType}'
      ' → ${change.nextState.runtimeType}',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    AppLogger.e('BLoC error: ${bloc.runtimeType}', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    AppLogger.d('BLoC close: ${bloc.runtimeType}');
    super.onClose(bloc);
  }
}
