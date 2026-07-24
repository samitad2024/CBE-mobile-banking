import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/utils/money_formatter.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';

/// Transaction row with signed amount colors (PDF p.10).
class TransactionListTile extends StatelessWidget {
  const TransactionListTile({
    required this.transaction,
    required this.onTap,
    super.key,
  });

  final TransactionEntity transaction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.direction == TransactionDirection.credit;
    final color = isCredit ? AppColors.credit : AppColors.debit;
    final sign = isCredit ? '+' : '-';
    final amount =
        '$sign${MoneyFormatter.formatEtb(transaction.amountEtb, withCode: false)}';
    final partner = transaction.partnerLabel;
    final initial = (partner ?? transaction.title).trim().isEmpty
        ? '?'
        : (partner ?? transaction.title).trim()[0].toUpperCase();

    return Material(
      color: AppColors.plum,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.peach.withValues(alpha: 0.18),
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: AppColors.peach,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatWhen(transaction.occurredAt),
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                    if (partner != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        partner,
                        style: TextStyle(
                          color: AppColors.peach.withValues(alpha: 0.85),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                '$amount\nETB',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatWhen(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} · $h:$m';
  }
}
