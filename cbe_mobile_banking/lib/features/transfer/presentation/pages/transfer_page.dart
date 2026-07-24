import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/utils/money_formatter.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/bloc/transfer_bloc.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/bloc/transfer_event.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/bloc/transfer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TransferBloc>()..add(const TransferStarted()),
      child: const _TransferView(),
    );
  }
}

class _TransferView extends StatelessWidget {
  const _TransferView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfer')),
      body: BlocConsumer<TransferBloc, TransferState>(
        listener: (context, state) {
          if (state is TransferFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is TransferSubmitting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TransferSuccessState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: AppColors.peach, size: 64),
                  const SizedBox(height: 16),
                  const Text('Transfer Successful'),
                  const SizedBox(height: 12),
                  Text(state.result.message, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  AppPrimaryButton(
                    label: 'Done',
                    onPressed: () {
                      context.read<TransferBloc>().add(const TransferReset());
                      Navigator.of(context).maybePop();
                    },
                  ),
                ],
              ),
            );
          }
          if (state is TransferConfirmState) {
            final d = state.draft;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Confirmation', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Text('Receiver: ${d.receiverName}'),
                  Text('Destination: ${d.destination}'),
                  Text('Amount: ${MoneyFormatter.formatEtb(d.amountEtb)}'),
                  const Spacer(),
                  AppPrimaryButton(
                    label: 'Confirm Transfer',
                    onPressed: () => context
                        .read<TransferBloc>()
                        .add(const TransferConfirmed()),
                  ),
                ],
              ),
            );
          }
          if (state is! TransferFormState) {
            return const SizedBox.shrink();
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Wrap(
                spacing: 8,
                children: TransferRail.values.map((rail) {
                  final selected = state.rail == rail;
                  return ChoiceChip(
                    label: Text(rail.name.toUpperCase()),
                    selected: selected,
                    onSelected: (_) => context
                        .read<TransferBloc>()
                        .add(TransferRailSelected(rail)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Receiver'),
                onChanged: (v) => context
                    .read<TransferBloc>()
                    .add(TransferReceiverChanged(v)),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: state.rail == TransferRail.payment
                      ? 'Payment Number'
                      : state.rail == TransferRail.wallet
                          ? 'Wallet Account'
                          : 'Account Number',
                ),
                onChanged: (v) => context
                    .read<TransferBloc>()
                    .add(TransferDestinationChanged(v)),
              ),
              const SizedBox(height: 12),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                onChanged: (v) =>
                    context.read<TransferBloc>().add(TransferAmountChanged(v)),
              ),
              if (state.validationMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  state.validationMessage!,
                  style: const TextStyle(color: AppColors.debit),
                ),
              ],
              const SizedBox(height: 24),
              AppPrimaryButton(
                label: 'Next',
                onPressed: () => context
                    .read<TransferBloc>()
                    .add(const TransferReviewRequested()),
              ),
            ],
          );
        },
      ),
    );
  }
}
