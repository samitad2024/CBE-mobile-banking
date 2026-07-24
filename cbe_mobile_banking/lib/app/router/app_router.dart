import 'package:cbe_mobile_banking/app/router/go_router_refresh_stream.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_state.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/pages/login_page.dart';
import 'package:cbe_mobile_banking/features/home/presentation/pages/home_page.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/pages/request_money_page.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/pages/requests_inbox_page.dart';
import 'package:cbe_mobile_banking/features/scan/presentation/pages/scan_page.dart';
import 'package:cbe_mobile_banking/features/settings/presentation/pages/settings_page.dart';
import 'package:cbe_mobile_banking/features/shell/presentation/pages/main_shell.dart';
import 'package:cbe_mobile_banking/features/transactions/presentation/pages/transactions_page.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_prefill.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/pages/transfer_page.dart';
import 'package:cbe_mobile_banking/features/wallet/presentation/pages/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Route path constants for PDF-mapped features.
abstract final class AppRoutes {
  static const String root = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String transfer = '/transfer';
  static const String requestMoney = '/request';
  static const String requestsInbox = '/requests';
  static const String scan = '/scan';
  static const String transactions = '/transactions';
  static const String wallet = '/wallet';
  static const String settings = '/settings';
}

abstract final class AppRouter {
  static GoRouter createRouter(AuthSessionBloc authSessionBloc) {
    return GoRouter(
      initialLocation: AppRoutes.login,
      refreshListenable: GoRouterRefreshStream(authSessionBloc),
      redirect: (BuildContext context, GoRouterState state) {
        final loc = state.matchedLocation;
        final sessionState = authSessionBloc.state;

        if (sessionState is AuthSessionUnknown) {
          return null;
        }

        final loggedIn = sessionState.isAuthenticated;
        final onLogin = loc == AppRoutes.login || loc == AppRoutes.root;

        if (!loggedIn && !onLogin) {
          return AppRoutes.login;
        }
        if (loggedIn && onLogin) {
          return AppRoutes.home;
        }
        if (loc == AppRoutes.root) {
          return loggedIn ? AppRoutes.home : AppRoutes.login;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.root,
          redirect: (BuildContext context, GoRouterState state) {
            return AppRoutes.login;
          },
        ),
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        StatefulShellRoute.indexedStack(
          builder: (
            BuildContext context,
            GoRouterState state,
            StatefulNavigationShell navigationShell,
          ) {
            return MainShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.home,
                  name: 'home',
                  builder: (BuildContext context, GoRouterState state) {
                    return const HomePage();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.scan,
                  name: 'scan',
                  builder: (BuildContext context, GoRouterState state) {
                    return const ScanPage();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.wallet,
                  name: 'wallet',
                  builder: (BuildContext context, GoRouterState state) {
                    return const WalletPage();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.settings,
                  name: 'settings',
                  builder: (BuildContext context, GoRouterState state) {
                    return const SettingsPage();
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.transfer,
          name: 'transfer',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra;
            final prefill = switch (extra) {
              final TransferPrefill value => value,
              final String raw => PaymentQrParser.tryParse(raw),
              _ => null,
            };
            return TransferPage(prefill: prefill);
          },
        ),
        GoRoute(
          path: AppRoutes.requestMoney,
          name: 'requestMoney',
          builder: (BuildContext context, GoRouterState state) {
            return const RequestMoneyPage();
          },
        ),
        GoRoute(
          path: AppRoutes.requestsInbox,
          name: 'requestsInbox',
          builder: (BuildContext context, GoRouterState state) {
            return const RequestsInboxPage();
          },
        ),
        GoRoute(
          path: AppRoutes.transactions,
          name: 'transactions',
          builder: (BuildContext context, GoRouterState state) {
            return const TransactionsPage();
          },
        ),
      ],
    );
  }
}
