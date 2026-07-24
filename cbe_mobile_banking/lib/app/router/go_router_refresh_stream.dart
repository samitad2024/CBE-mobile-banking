import 'dart:async';

import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_state.dart';
import 'package:flutter/foundation.dart';

/// Bridges [AuthSessionBloc] to go_router refreshListenable.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(AuthSessionBloc authSessionBloc) {
    notifyListeners();
    _subscription = authSessionBloc.stream.listen((AuthSessionState _) {
      notifyListeners();
    });
  }

  late final StreamSubscription<AuthSessionState> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
