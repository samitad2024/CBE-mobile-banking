import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:flutter/material.dart';

/// Horizontal "Transfer Again" avatars (PDF p.2).
class HomeTransferAgainRow extends StatelessWidget {
  const HomeTransferAgainRow({
    required this.recipients,
    this.onRecipientTap,
    super.key,
  });

  final List<RecentRecipientEntity> recipients;
  final ValueChanged<RecentRecipientEntity>? onRecipientTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transfer Again',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        if (recipients.isEmpty)
          Text(
            'No recent recipients',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.muted,
                ),
          )
        else
          SizedBox(
            height: 78,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recipients.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final r = recipients[index];
                return InkWell(
                  onTap: onRecipientTap == null
                      ? null
                      : () => onRecipientTap!(r),
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 52,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.peach,
                          child: Text(
                            r.initial,
                            style: const TextStyle(
                              color: AppColors.plum,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          r.lastFour,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
