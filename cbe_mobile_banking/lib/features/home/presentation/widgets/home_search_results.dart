import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/features/home/domain/entities/home_search_hit.dart';
import 'package:flutter/material.dart';

/// Inline search results under the Home search field.
class HomeSearchResults extends StatelessWidget {
  const HomeSearchResults({
    required this.hits,
    required this.query,
    required this.onSelect,
    super.key,
  });

  final List<HomeSearchHit> hits;
  final String query;
  final ValueChanged<HomeSearchHit> onSelect;

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) return const SizedBox.shrink();

    if (hits.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          'No matches for “$query”',
          style: const TextStyle(color: AppColors.muted, fontSize: 13),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: hits
            .map(
              (hit) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: AppColors.plum,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: () => onSelect(hit),
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _iconFor(hit.destination),
                            color: AppColors.peach,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hit.title,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  hit.subtitle,
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.muted,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  static IconData _iconFor(HomeSearchDestination destination) {
    return switch (destination) {
      HomeSearchDestination.transfer => Icons.north_east,
      HomeSearchDestination.requestMoney => Icons.south_west,
      HomeSearchDestination.requestsInbox => Icons.inbox_outlined,
      HomeSearchDestination.transactions => Icons.receipt_long_outlined,
      HomeSearchDestination.scan => Icons.qr_code_scanner,
      HomeSearchDestination.wallet => Icons.account_balance_wallet_outlined,
      HomeSearchDestination.settings => Icons.settings_outlined,
    };
  }
}
