import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/widgets/app_empty_state.dart';
import 'package:cbe_mobile_banking/core/widgets/app_error_state.dart';
import 'package:cbe_mobile_banking/core/widgets/app_loading_indicator.dart';
import 'package:cbe_mobile_banking/core/widgets/secure_screen.dart';
import 'package:cbe_mobile_banking/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:cbe_mobile_banking/features/transactions/presentation/bloc/transactions_event.dart';
import 'package:cbe_mobile_banking/features/transactions/presentation/bloc/transactions_state.dart';
import 'package:cbe_mobile_banking/features/transactions/presentation/widgets/receipt_detail_sheet.dart';
import 'package:cbe_mobile_banking/features/transactions/presentation/widgets/transaction_list_tile.dart';
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

class _TransactionsView extends StatefulWidget {
  const _TransactionsView();

  @override
  State<_TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<_TransactionsView> {
  bool _sheetOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.plumDeep,
      appBar: AppBar(
        title: Text(
          'Transactions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.peach,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
        ),
      ),
      body: BlocConsumer<TransactionsBloc, TransactionsState>(
        listenWhen: (previous, current) {
          if (current is! TransactionsLoaded ||
              current.selectedReceipt == null) {
            return false;
          }
          if (previous is! TransactionsLoaded) return true;
          return previous.selectedReceipt == null;
        },
        listener: (context, state) {
          if (state is! TransactionsLoaded || state.selectedReceipt == null) {
            return;
          }
          _openReceiptSheet(context, state);
        },
        builder: (context, state) {
          if (state is TransactionsLoading || state is TransactionsInitial) {
            return const AppLoadingIndicator(label: 'Loading transactions…');
          }
          if (state is TransactionsFailureState) {
            return AppErrorState(
              message: state.message,
              onRetry: () => context
                  .read<TransactionsBloc>()
                  .add(const TransactionsRefreshed()),
            );
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
          return RefreshIndicator(
            color: AppColors.peach,
            onRefresh: () async {
              context
                  .read<TransactionsBloc>()
                  .add(const TransactionsRefreshed());
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final tx = state.items[index];
                return TransactionListTile(
                  transaction: tx,
                  onTap: () => context
                      .read<TransactionsBloc>()
                      .add(TransactionSelected(tx.id)),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _openReceiptSheet(
    BuildContext context,
    TransactionsLoaded state,
  ) async {
    if (_sheetOpen || state.selectedReceipt == null) return;
    _sheetOpen = true;
    final receipt = state.selectedReceipt!;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.plum,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SecureScreen(
          child: ReceiptDetailSheet(
            receipt: receipt,
            onClose: () => Navigator.of(sheetContext).pop(),
          ),
        );
      },
    ).whenComplete(() {
      _sheetOpen = false;
      if (!context.mounted) return;
      context.read<TransactionsBloc>().add(const ReceiptDismissed());
    });
  }
}
