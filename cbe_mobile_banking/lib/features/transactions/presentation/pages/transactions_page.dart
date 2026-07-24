import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/utils/money_formatter.dart';
import 'package:cbe_mobile_banking/core/widgets/app_empty_state.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/entities/transaction_entity.dart';
import 'package:cbe_mobile_banking/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:cbe_mobile_banking/features/transactions/presentation/bloc/transactions_event.dart';
import 'package:cbe_mobile_banking/features/transactions/presentation/bloc/transactions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<TransactionsBloc>()..add(const TransactionsStarted()),
      child: const _TransactionsView(),
    );
  }
}

class _TransactionsView extends StatelessWidget {
  const _TransactionsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: BlocConsumer<TransactionsBloc, TransactionsState>(
        listener: (context, state) {
          if (state is TransactionsLoaded && state.selectedReceipt != null) {
            final receipt = state.selectedReceipt!;
            showModalBottomSheet<void>(
              context: context,
              builder: (_) => Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Receipt Detail',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text('Receiver: ${receipt.receiverName}'),
                    Text('Number: ${receipt.receiverNumber}'),
                    Text(
                      'Amount: ${MoneyFormatter.formatEtb(receipt.amountEtb)}',
                    ),
                    Text('Txn: ${receipt.transactionNumber}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context
                            .read<TransactionsBloc>()
                            .add(const ReceiptDismissed());
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ).whenComplete(() {
              if (context.mounted) {
                context.read<TransactionsBloc>().add(const ReceiptDismissed());
              }
            });
          }
        },
        builder: (context, state) {
          if (state is TransactionsLoading || state is TransactionsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TransactionsFailureState) {
            return Center(child: Text(state.message));
          }
          if (state is! TransactionsLoaded) {
            return const SizedBox.shrink();
          }
          if (state.items.isEmpty) {
            return const AppEmptyState(
              title: 'No transactions',
              subtitle: 'Your recent transfers and payments will show here.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final tx = state.items[index];
              final isCredit = tx.direction == TransactionDirection.credit;
              final color = isCredit ? AppColors.credit : AppColors.debit;
              final sign = isCredit ? '+' : '-';
              return ListTile(
                tileColor: AppColors.plum,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(tx.title),
                subtitle: Text(
                  '${tx.occurredAt.year}-${tx.occurredAt.month}-${tx.occurredAt.day}',
                ),
                trailing: Text(
                  '$sign${tx.amountEtb.toStringAsFixed(0)}\nETB',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
                onTap: () => context
                    .read<TransactionsBloc>()
                    .add(TransactionSelected(tx.id)),
              );
            },
          );
        },
      ),
    );
  }
}
