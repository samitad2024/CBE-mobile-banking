import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/core/widgets/app_secondary_button.dart';
import 'package:flutter/material.dart';

/// Transfer | Request dual toggle used on money-movement screens.
class TransferRequestToggle extends StatelessWidget {
  const TransferRequestToggle({
    required this.isTransfer,
    required this.onTransfer,
    required this.onRequest,
    super.key,
  });

  final bool isTransfer;
  final VoidCallback onTransfer;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: isTransfer
              ? AppPrimaryButton(
                  label: 'Transfer',
                  icon: Icons.north_east,
                  onPressed: onTransfer,
                )
              : AppSecondaryButton(
                  label: 'Transfer',
                  icon: Icons.north_east,
                  onPressed: onTransfer,
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: !isTransfer
              ? AppPrimaryButton(
                  label: 'Request',
                  icon: Icons.south_west,
                  onPressed: onRequest,
                )
              : AppSecondaryButton(
                  label: 'Request',
                  icon: Icons.south_west,
                  onPressed: onRequest,
                ),
        ),
      ],
    );
  }
}

/// Compact session account strip for Transfer/Request chrome.
class TransferAccountStrip extends StatelessWidget {
  const TransferAccountStrip({
    required this.customerName,
    required this.maskedAccount,
    super.key,
  });

  final String customerName;
  final String maskedAccount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.peach,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            customerName,
            style: const TextStyle(
              color: AppColors.plum,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            maskedAccount,
            style: TextStyle(
              color: AppColors.plum.withValues(alpha: 0.85),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
