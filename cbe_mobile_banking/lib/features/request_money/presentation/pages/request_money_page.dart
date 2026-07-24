import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/utils/money_formatter.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/payment_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/bloc/request_money_bloc.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/bloc/request_money_event.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/bloc/request_money_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestMoneyPage extends StatelessWidget {
  const RequestMoneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<RequestMoneyBloc>()..add(const RequestMoneyStarted()),
      child: const _RequestMoneyView(),
    );
  }
}

class _RequestMoneyView extends StatelessWidget {
  const _RequestMoneyView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request')),
      body: BlocConsumer<RequestMoneyBloc, RequestMoneyState>(
        listener: (context, state) {
          if (state is RequestMoneyFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is RequestMoneySubmitting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RequestMoneySuccessState) {
            final r = state.request;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    r.mode == RequestMode.qr
                        ? 'QR Generated'
                        : 'Request Sent',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(MoneyFormatter.formatEtb(r.amountEtb)),
                  if (r.qrPayload != null) ...[
                    const SizedBox(height: 16),
                    Text(r.qrPayload!, textAlign: TextAlign.center),
                  ],
                  const SizedBox(height: 24),
                  AppPrimaryButton(
                    label: 'New Request',
                    onPressed: () => context
                        .read<RequestMoneyBloc>()
                        .add(const RequestMoneyStarted()),
                  ),
                ],
              ),
            );
          }
          if (state is! RequestMoneyFormState) {
            return const SizedBox.shrink();
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              SegmentedButton<RequestMode>(
                segments: const [
                  ButtonSegment(value: RequestMode.qr, label: Text('QR')),
                  ButtonSegment(
                    value: RequestMode.account,
                    label: Text('Account'),
                  ),
                ],
                selected: {state.mode},
                onSelectionChanged: (s) => context
                    .read<RequestMoneyBloc>()
                    .add(RequestModeSelected(s.first)),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                onChanged: (v) => context
                    .read<RequestMoneyBloc>()
                    .add(RequestAmountChanged(v)),
              ),
              if (state.mode == RequestMode.account) ...[
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(labelText: 'Account'),
                  onChanged: (v) => context
                      .read<RequestMoneyBloc>()
                      .add(RequestAccountChanged(v)),
                ),
              ],
              if (state.validationMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  state.validationMessage!,
                  style: const TextStyle(color: AppColors.debit),
                ),
              ],
              const SizedBox(height: 24),
              AppPrimaryButton(
                label: state.mode == RequestMode.qr
                    ? 'Generate QR code'
                    : 'Send Request',
                onPressed: () => context.read<RequestMoneyBloc>().add(
                      RequestSubmitted(
                        idempotencyKey:
                            'req-${DateTime.now().millisecondsSinceEpoch}',
                      ),
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}
