import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/app/router/app_router.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/core/widgets/app_search_field.dart';
import 'package:cbe_mobile_banking/core/widgets/app_secondary_button.dart';
import 'package:cbe_mobile_banking/features/home/domain/entities/home_search_hit.dart';
import 'package:cbe_mobile_banking/features/home/presentation/bloc/home_bloc.dart';
import 'package:cbe_mobile_banking/features/home/presentation/bloc/home_event.dart';
import 'package:cbe_mobile_banking/features/home/presentation/bloc/home_state.dart';
import 'package:cbe_mobile_banking/features/home/presentation/widgets/home_balance_card.dart';
import 'package:cbe_mobile_banking/features/home/presentation/widgets/home_requests_banner.dart';
import 'package:cbe_mobile_banking/features/home/presentation/widgets/home_search_results.dart';
import 'package:cbe_mobile_banking/features/home/presentation/widgets/home_service_tile.dart';
import 'package:cbe_mobile_banking/features/home/presentation/widgets/home_transfer_again_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const HomeStarted()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.plumDeep,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeFailureState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    TextButton(
                      onPressed: () =>
                          context.read<HomeBloc>().add(const HomeRefreshed()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (state is! HomeLoaded) {
              return const SizedBox.shrink();
            }

            return RefreshIndicator(
              color: AppColors.peach,
              onRefresh: () async {
                context.read<HomeBloc>().add(const HomeRefreshed());
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                children: [
                  AppSearchField(
                    onQrTap: () => context.go(AppRoutes.scan),
                    onChanged: (q) =>
                        context.read<HomeBloc>().add(HomeSearchChanged(q)),
                  ),
                  const SizedBox(height: 10),
                  HomeSearchResults(
                    query: state.searchQuery,
                    hits: state.searchHits,
                    onSelect: (hit) => _openHit(context, hit),
                  ),
                  const SizedBox(height: 8),
                  HomeBalanceCard(
                    account: state.dashboard.account,
                    isBalanceVisible: state.isBalanceVisible,
                    onToggleVisibility: () => context.read<HomeBloc>().add(
                          const HomeBalanceVisibilityToggled(),
                        ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: AppPrimaryButton(
                          label: 'Transfer',
                          icon: Icons.north_east,
                          onPressed: () => context.push(AppRoutes.transfer),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppSecondaryButton(
                          label: 'Request',
                          icon: Icons.south_west,
                          onPressed: () =>
                              context.push(AppRoutes.requestMoney),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  HomeRequestsBanner(
                    count: state.dashboard.pendingRequestCount,
                    onProceed: () => context.push(AppRoutes.requestsInbox),
                  ),
                  const SizedBox(height: 22),
                  HomeTransferAgainRow(
                    recipients: state.dashboard.recentRecipients,
                    onRecipientTap: (_) => context.push(AppRoutes.transfer),
                  ),
                  const SizedBox(height: 20),
                  HomeServiceTile(
                    icon: Icons.account_balance_outlined,
                    title: 'Transfer to Bank',
                    subtitle: 'Transfer across 31 banks in the country',
                    onTap: () => context.push(AppRoutes.transfer),
                  ),
                  const SizedBox(height: 10),
                  HomeServiceTile(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Transfer to Wallet',
                    subtitle: 'CBE birr, Tele birr and 17 more',
                    onTap: () => context.push(AppRoutes.transfer),
                  ),
                  const SizedBox(height: 10),
                  HomeServiceTile(
                    icon: Icons.payments_outlined,
                    title: 'Payments',
                    subtitle: 'Utilities, schools, and merchants',
                    onTap: () => context.push(AppRoutes.transfer),
                  ),
                  const SizedBox(height: 10),
                  HomeServiceTile(
                    icon: Icons.receipt_long_outlined,
                    title: 'Transactions',
                    subtitle: 'View history and download receipts',
                    onTap: () => context.push(AppRoutes.transactions),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _openHit(BuildContext context, HomeSearchHit hit) {
    switch (hit.destination) {
      case HomeSearchDestination.transfer:
        context.push(AppRoutes.transfer);
      case HomeSearchDestination.requestMoney:
        context.push(AppRoutes.requestMoney);
      case HomeSearchDestination.requestsInbox:
        context.push(AppRoutes.requestsInbox);
      case HomeSearchDestination.transactions:
        context.push(AppRoutes.transactions);
      case HomeSearchDestination.scan:
        context.go(AppRoutes.scan);
      case HomeSearchDestination.wallet:
        context.go(AppRoutes.wallet);
      case HomeSearchDestination.settings:
        context.go(AppRoutes.settings);
    }
  }
}
