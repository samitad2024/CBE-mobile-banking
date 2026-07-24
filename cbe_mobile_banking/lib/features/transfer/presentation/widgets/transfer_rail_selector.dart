import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';
import 'package:flutter/material.dart';

/// Payment | Bank | Wallet segment (PDF p.3–5).
class TransferRailSelector extends StatelessWidget {
  const TransferRailSelector({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final TransferRail selected;
  final ValueChanged<TransferRail> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.plum,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: TransferRail.values.map((rail) {
          final isSelected = rail == selected;
          return Expanded(
            child: Material(
              color: isSelected ? AppColors.peach : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: () => onSelected(rail),
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    _label(rail),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? AppColors.plum : AppColors.peach,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static String _label(TransferRail rail) {
    return switch (rail) {
      TransferRail.payment => 'Payment',
      TransferRail.bank => 'Bank',
      TransferRail.wallet => 'Wallet',
    };
  }
}
