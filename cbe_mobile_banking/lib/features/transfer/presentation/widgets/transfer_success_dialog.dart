import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/core/widgets/app_secondary_button.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Transfer success modal (PDF p.7).
class TransferSuccessDialog extends StatelessWidget {
  const TransferSuccessDialog({
    required this.result,
    required this.onClose,
    required this.onReceipt,
    super.key,
  });

  final TransferResultEntity result;
  final VoidCallback onClose;
  final VoidCallback onReceipt;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.plum,
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              color: AppColors.peach,
              child: const Column(
                children: [
                  Icon(Icons.check_circle, color: AppColors.plum, size: 40),
                  SizedBox(height: 10),
                  Text(
                    'Transfer Successful',
                    style: TextStyle(
                      color: AppColors.plum,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                children: [
                  Text(
                    result.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.white,
                      height: 1.45,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(text: result.transactionId),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Transaction ID copied'),
                          ),
                        );
                      }
                    },
                    child: Text(
                      result.transactionId,
                      style: const TextStyle(
                        color: AppColors.peach,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: AppSecondaryButton(
                          label: 'Close',
                          onPressed: onClose,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppPrimaryButton(
                          label: 'Receipt',
                          onPressed: onReceipt,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
