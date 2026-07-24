import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/core/widgets/app_empty_state.dart';
import 'package:cbe_mobile_banking/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WalletBloc>()..add(const WalletStarted()),
      child: const _WalletView(),
    );
  }
}

class _WalletView extends StatelessWidget {
  const _WalletView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          if (state is WalletLoading || state is WalletInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is! WalletLoaded) {
            return const SizedBox.shrink();
          }
          if (state.linkedWallets.isEmpty) {
            return const AppEmptyState(
              title: 'No wallets',
              subtitle: 'Linked wallets will appear here.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.linkedWallets.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: Text(state.linkedWallets[index]),
                subtitle: const Text('Linked (mock)'),
              );
            },
          );
        },
      ),
    );
  }
}
