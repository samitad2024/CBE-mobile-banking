import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/app/router/app_router.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/utils/account_masker.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/core/widgets/app_search_field.dart';
import 'package:cbe_mobile_banking/core/widgets/secure_screen.dart';
import 'package:cbe_mobile_banking/core/widgets/transfer_request_toggle.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_state.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/bloc/transfer_bloc.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/bloc/transfer_event.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/bloc/transfer_state.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/widgets/transfer_confirm_sheet.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/widgets/transfer_rail_selector.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/widgets/transfer_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TransferBloc>()..add(const TransferStarted()),
      child: const SecureScreen(child: _TransferView()),
    );
  }
}

class _TransferView extends StatefulWidget {
  const _TransferView();

  @override
  State<_TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<_TransferView> {
  bool _sheetOpen = false;
  bool _dialogOpen = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransferBloc, TransferState>(
      listenWhen: (previous, current) {
        if (current is TransferFailureState) return true;
        if (current is TransferSuccessState) return true;
        if (current is TransferConfirmState &&
            previous is! TransferConfirmState &&
            previous is! TransferSubmitting) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is TransferFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is TransferConfirmState) {
          _openConfirmSheet(context, state);
        }
        if (state is TransferSuccessState) {
          _openSuccessDialog(context, state);
        }
      },
      builder: (context, state) {
        final form = state is TransferFormState
            ? state
            : state is TransferConfirmState
                ? TransferFormState(
                    rail: state.draft.rail,
                    receiverName: state.draft.receiverName,
                    destination: state.draft.destination,
                    amountText: state.draft.amountEtb.toStringAsFixed(2),
                  )
                : state is TransferSubmitting
                    ? TransferFormState(
                        rail: state.draft.rail,
                        receiverName: state.draft.receiverName,
                        destination: state.draft.destination,
                        amountText: state.draft.amountEtb.toStringAsFixed(2),
                      )
                    : state is TransferSuccessState
                        ? TransferFormState(
                            receiverName: state.result.receiverName,
                            destination: state.result.destination,
                            amountText:
                                state.result.amountEtb.toStringAsFixed(2),
                          )
                        : const TransferFormState();

        final session = context.watch<AuthSessionBloc>().state;
        final name = session is AuthSessionAuthenticated
            ? session.session.customerName
            : 'CBE Customer';
        final account = session is AuthSessionAuthenticated
            ? AccountMasker.mask(session.session.accountNumber)
            : '****';

        final editable = state is TransferFormState;

        return Scaffold(
          backgroundColor: AppColors.plumDeep,
          appBar: AppBar(
            title: const Text('Transfer'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: ListView(
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
                isTransfer: true,
                onTransfer: () {},
                onRequest: () => context.pushReplacement(AppRoutes.requestMoney),
              ),
              const SizedBox(height: 18),
              TransferRailSelector(
                selected: form.rail,
                onSelected: editable
                    ? (rail) => context
                        .read<TransferBloc>()
                        .add(TransferRailSelected(rail))
                    : (_) {},
              ),
              const SizedBox(height: 18),
              _LabeledField(
                label: _receiverLabel(form.rail),
                enabled: editable,
                initialValue: form.receiverName,
                onChanged: (v) => context
                    .read<TransferBloc>()
                    .add(TransferReceiverChanged(v)),
              ),
              const SizedBox(height: 12),
              _LabeledField(
                label: _destinationLabel(form.rail),
                enabled: editable,
                initialValue: form.destination,
                onChanged: (v) => context
                    .read<TransferBloc>()
                    .add(TransferDestinationChanged(v)),
              ),
              const SizedBox(height: 12),
              _LabeledField(
                label: 'Amount',
                enabled: editable,
                initialValue: form.amountText,
                keyboardType: TextInputType.number,
                onChanged: (v) => context
                    .read<TransferBloc>()
                    .add(TransferAmountChanged(v)),
              ),
              if (form.validationMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  form.validationMessage!,
                  style: const TextStyle(color: AppColors.debit),
                ),
              ],
              const SizedBox(height: 24),
              AppPrimaryButton(
                label: 'Next',
                onPressed: editable
                    ? () => context
                        .read<TransferBloc>()
                        .add(const TransferReviewRequested())
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openConfirmSheet(
    BuildContext context,
    TransferConfirmState state,
  ) async {
    if (_sheetOpen) return;
    _sheetOpen = true;
    final draft = state.draft;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.plum,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: context.read<TransferBloc>(),
          child: BlocBuilder<TransferBloc, TransferState>(
            builder: (context, s) {
              final d = s is TransferConfirmState
                  ? s.draft
                  : s is TransferSubmitting
                      ? s.draft
                      : draft;
              final submitting = s is TransferSubmitting;
              return TransferConfirmSheet(
                draft: d,
                isSubmitting: submitting,
                onConfirm: () {
                  context.read<TransferBloc>().add(
                        TransferConfirmed(
                          idempotencyKey:
                              'tx-${DateTime.now().millisecondsSinceEpoch}',
                        ),
                      );
                },
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      _sheetOpen = false;
      if (!context.mounted) return;
      final current = context.read<TransferBloc>().state;
      if (current is TransferConfirmState) {
        context.read<TransferBloc>().add(const TransferConfirmDismissed());
      }
    });
  }

  Future<void> _openSuccessDialog(
    BuildContext context,
    TransferSuccessState state,
  ) async {
    if (_dialogOpen) return;
    if (_sheetOpen) {
      await Navigator.of(context, rootNavigator: true).maybePop();
      _sheetOpen = false;
    }
    if (!context.mounted) return;
    _dialogOpen = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return TransferSuccessDialog(
          result: state.result,
          onClose: () {
            Navigator.of(dialogContext).pop();
            context.read<TransferBloc>().add(const TransferReset());
            context.go(AppRoutes.home);
          },
          onReceipt: () {
            Navigator.of(dialogContext).pop();
            context.read<TransferBloc>().add(const TransferReset());
            context.push(AppRoutes.transactions);
          },
        );
      },
    ).whenComplete(() {
      _dialogOpen = false;
    });
  }

  static String _receiverLabel(TransferRail rail) {
    return switch (rail) {
      TransferRail.bank => 'Bank',
      TransferRail.payment => 'Receiver',
      TransferRail.wallet => 'Wallet Name',
    };
  }

  static String _destinationLabel(TransferRail rail) {
    return switch (rail) {
      TransferRail.bank => 'Account Number',
      TransferRail.payment => 'Payment Number',
      TransferRail.wallet => 'Account Number',
    };
  }
}

class _LabeledField extends StatefulWidget {
  const _LabeledField({
    required this.label,
    required this.onChanged,
    required this.enabled,
    this.initialValue = '',
    this.keyboardType,
  });

  final String label;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final String initialValue;
  final TextInputType? keyboardType;

  @override
  State<_LabeledField> createState() => _LabeledFieldState();
}

class _LabeledFieldState extends State<_LabeledField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _LabeledField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      style: const TextStyle(color: AppColors.white),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(color: AppColors.muted),
      ),
    );
  }
}
