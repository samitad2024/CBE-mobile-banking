import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/utils/money_formatter.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';
import 'package:flutter/material.dart';

/// Confirm transfer bottom sheet body (PDF p.6).
class TransferConfirmSheet extends StatelessWidget {
  const TransferConfirmSheet({
    required this.draft,
    required this.onConfirm,
    this.isSubmitting = false,
    super.key,
  });

  final TransferDraftEntity draft;
  final VoidCallback onConfirm;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.muted.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Confirmation',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 20),
            _row('Receiver', draft.receiverName),
            const SizedBox(height: 14),
            _row('Receiver Number', draft.destination),
            const SizedBox(height: 14),
            _row(
              'Amount',
              MoneyFormatter.formatEtb(draft.amountEtb),
              emphasize: true,
            ),
            const SizedBox(height: 28),
            AppPrimaryButton(
              label: isSubmitting ? 'Transferring…' : 'Confirm Transfer',
              onPressed: isSubmitting ? null : onConfirm,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool emphasize = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
              fontSize: emphasize ? 18 : 14,
            ),
          ),
        ),
      ],
    );
  }
}
