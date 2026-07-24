import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/app/router/app_router.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/utils/account_masker.dart';
import 'package:cbe_mobile_banking/core/utils/money_formatter.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/features/home/presentation/bloc/home_bloc.dart';
import 'package:cbe_mobile_banking/features/home/presentation/bloc/home_event.dart';
import 'package:cbe_mobile_banking/features/home/presentation/bloc/home_state.dart';
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
      appBar: AppBar(title: const Text('Home')),
      body: BlocBuilder<HomeBloc, HomeState>(
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
          final account = state.dashboard.account;
          final balanceText = state.isBalanceVisible
              ? MoneyFormatter.formatEtb(account.balanceEtb)
              : '****** ETB';
          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(const HomeRefreshed());
            },
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Card(
                  color: AppColors.peach,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.customerName,
                          style: const TextStyle(
                            color: AppColors.plum,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          AccountMasker.mask(account.accountNumber),
                          style: const TextStyle(color: AppColors.plum),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          balanceText,
                          style: const TextStyle(
                            color: AppColors.plum,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => context.read<HomeBloc>().add(
                                  const HomeBalanceVisibilityToggled(),
                                ),
                            child: Text(
                              state.isBalanceVisible ? 'Hide' : 'Show',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (state.dashboard.pendingRequestCount > 0)
                  ListTile(
                    tileColor: AppColors.plum,
                    title: Text(
                      '${state.dashboard.pendingRequestCount} Requests',
                      style: const TextStyle(color: AppColors.white),
                    ),
                    trailing: const Text(
                      'Proceed',
                      style: TextStyle(color: AppColors.peach),
                    ),
                  ),
                const SizedBox(height: 16),
                AppPrimaryButton(
                  label: 'Transfer',
                  onPressed: () => context.push(AppRoutes.transfer),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.push(AppRoutes.requestMoney),
                  child: const Text('Request'),
                ),
                const SizedBox(height: 24),
                Text(
                  'Transfer Again',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 72,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.dashboard.recentRecipients.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final r = state.dashboard.recentRecipients[index];
                      return Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.peach,
                            child: Text(
                              r.initial,
                              style: const TextStyle(color: AppColors.plum),
                            ),
                          ),
                          Text(r.lastFour),
                        ],
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(AppRoutes.transactions),
                  child: const Text('Transactions'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
