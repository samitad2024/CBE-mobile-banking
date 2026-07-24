import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/app/router/app_router.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/utils/account_masker.dart';
import 'package:cbe_mobile_banking/core/utils/money_formatter.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/core/widgets/app_search_field.dart';
import 'package:cbe_mobile_banking/core/widgets/app_secondary_button.dart';
import 'package:cbe_mobile_banking/core/widgets/transfer_request_toggle.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_state.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/payment_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/bloc/request_money_bloc.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/bloc/request_money_event.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/bloc/request_money_state.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/widgets/request_mode_card.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/widgets/request_qr_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
      backgroundColor: AppColors.plumDeep,
      appBar: AppBar(
        title: const Text('Request'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
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
            return _SuccessView(request: state.request);
          }
          if (state is! RequestMoneyFormState) {
            return const SizedBox.shrink();
          }

          final session = context.watch<AuthSessionBloc>().state;
          final name = session is AuthSessionAuthenticated
              ? session.session.customerName
              : 'CBE Customer';
          final account = session is AuthSessionAuthenticated
              ? AccountMasker.mask(session.session.accountNumber)
              : '****';

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              const AppSearchField(),
              const SizedBox(height: 16),
              TransferAccountStrip(
                customerName: name,
                maskedAccount: account,
              ),
              const SizedBox(height: 16),
              TransferRequestToggle(
                isTransfer: false,
                onTransfer: () =>
                    context.pushReplacement(AppRoutes.transfer),
                onRequest: () {},
              ),
              const SizedBox(height: 20),
              RequestModeCard(
                title: 'Receive via QR',
                selected: state.mode == RequestMode.qr,
                onTap: () => context
                    .read<RequestMoneyBloc>()
                    .add(const RequestModeSelected(RequestMode.qr)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      enabled: state.mode == RequestMode.qr,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.white),
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        labelStyle: TextStyle(color: AppColors.muted),
                      ),
                      onChanged: (v) => context
                          .read<RequestMoneyBloc>()
                          .add(RequestAmountChanged(v)),
                    ),
                    const SizedBox(height: 14),
                    AppPrimaryButton(
                      label: 'Generate QR code',
                      onPressed: state.mode == RequestMode.qr
                          ? () => context.read<RequestMoneyBloc>().add(
                                RequestSubmitted(
                                  idempotencyKey:
                                      'req-${DateTime.now().millisecondsSinceEpoch}',
                                ),
                              )
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              RequestModeCard(
                title: 'Receive via Account',
                selected: state.mode == RequestMode.account,
                onTap: () => context
                    .read<RequestMoneyBloc>()
                    .add(const RequestModeSelected(RequestMode.account)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      enabled: state.mode == RequestMode.account,
                      style: const TextStyle(color: AppColors.white),
                      decoration: const InputDecoration(
                        labelText: 'Account',
                        labelStyle: TextStyle(color: AppColors.muted),
                      ),
                      onChanged: (v) => context
                          .read<RequestMoneyBloc>()
                          .add(RequestAccountChanged(v)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      enabled: state.mode == RequestMode.account,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.white),
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        labelStyle: TextStyle(color: AppColors.muted),
                      ),
                      onChanged: (v) => context
                          .read<RequestMoneyBloc>()
                          .add(RequestAmountChanged(v)),
                    ),
                    const SizedBox(height: 14),
                    AppPrimaryButton(
                      label: 'Send Request',
                      onPressed: state.mode == RequestMode.account
                          ? () => context.read<RequestMoneyBloc>().add(
                                RequestSubmitted(
                                  idempotencyKey:
                                      'req-${DateTime.now().millisecondsSinceEpoch}',
                                ),
                              )
                          : null,
                    ),
                  ],
                ),
              ),
              if (state.validationMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  state.validationMessage!,
                  style: const TextStyle(color: AppColors.debit),
                ),
              ],
              const SizedBox(height: 20),
              AppSecondaryButton(
                label: 'Scan QR code',
                icon: Icons.qr_code_scanner,
                onPressed: () => _openScanSheet(context),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openScanSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.plum,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return ScanQrSheet(
          onMockDetect: () {
            Navigator.of(sheetContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mock QR detected: CBE|PAY|MOCK'),
              ),
            );
          },
        );
      },
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.request});

  final PaymentRequestEntity request;

  @override
  Widget build(BuildContext context) {
    final isQr = request.mode == RequestMode.qr;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          Text(
            isQr ? 'QR Generated' : 'Request Sent',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            MoneyFormatter.formatEtb(request.amountEtb),
            style: const TextStyle(
              color: AppColors.peach,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (request.qrPayload != null) ...[
            const SizedBox(height: 24),
            MockQrPreview(payload: request.qrPayload!),
            const SizedBox(height: 12),
            Text(
              request.qrPayload!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ],
          const Spacer(),
          AppPrimaryButton(
            label: 'New Request',
            onPressed: () => context
                .read<RequestMoneyBloc>()
                .add(const RequestMoneyStarted()),
          ),
          const SizedBox(height: 12),
          AppSecondaryButton(
            label: 'Done',
            onPressed: () => context.go(AppRoutes.home),
          ),
        ],
      ),
    );
  }
}
