import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/utils/money_formatter.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Receipt detail bottom sheet (PDF p.11).
class ReceiptDetailSheet extends StatelessWidget {
  const ReceiptDetailSheet({
    required this.receipt,
    required this.onClose,
    super.key,
  });

  final ReceiptEntity receipt;
  final VoidCallback onClose;

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
            const SizedBox(height: 18),
            Text(
              'Receipt Detail',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 20),
            _row('Receiver', receipt.receiverName),
            const SizedBox(height: 14),
            _row('Receiver Number', receipt.receiverNumber),
            const SizedBox(height: 14),
            _row(
              'Amount',
              MoneyFormatter.formatEtb(receipt.amountEtb),
              emphasize: true,
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: () async {
                await Clipboard.setData(
                  ClipboardData(text: receipt.transactionNumber),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transaction ID copied')),
                  );
                }
              },
              child: _row('Transaction ID', receipt.transactionNumber),
            ),
            const SizedBox(height: 28),
            AppPrimaryButton(
              label: 'View Receipt',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Receipt download coming soon (mock)'),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onClose,
              child: const Text(
                'Close',
                style: TextStyle(color: AppColors.peach),
              ),
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
              color: emphasize ? AppColors.peach : AppColors.white,
              fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
              fontSize: emphasize ? 18 : 14,
            ),
          ),
        ),
      ],
    );
  }
}
