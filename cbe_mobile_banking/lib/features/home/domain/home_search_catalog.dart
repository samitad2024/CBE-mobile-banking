import 'package:cbe_mobile_banking/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:cbe_mobile_banking/features/home/domain/entities/home_search_hit.dart';

/// Filters dashboard + shortcut catalog for the Home search field.
abstract final class HomeSearchCatalog {
  static List<HomeSearchHit> query(
    String raw, {
    required HomeDashboardEntity dashboard,
  }) {
    final q = raw.trim().toLowerCase();
    if (q.isEmpty) return const [];

    final hits = <HomeSearchHit>[
      ..._shortcuts.where((h) => _matches(h, q)),
      ...dashboard.recentRecipients
          .where(
            (r) =>
                r.fullName.toLowerCase().contains(q) ||
                r.lastFour.contains(q) ||
                r.accountNumber.contains(q),
          )
          .map(
            (r) => HomeSearchHit(
              title: r.fullName,
              subtitle: 'Transfer again · ${r.lastFour}',
              destination: HomeSearchDestination.transfer,
            ),
          ),
    ];
    return hits.take(8).toList(growable: false);
  }

  static bool _matches(HomeSearchHit hit, String q) {
    return hit.title.toLowerCase().contains(q) ||
        hit.subtitle.toLowerCase().contains(q);
  }

  static const _shortcuts = <HomeSearchHit>[
    HomeSearchHit(
      title: 'Transfer',
      subtitle: 'Send money to bank, payment, or wallet',
      destination: HomeSearchDestination.transfer,
    ),
    HomeSearchHit(
      title: 'Request money',
      subtitle: 'Create QR or account request',
      destination: HomeSearchDestination.requestMoney,
    ),
    HomeSearchHit(
      title: 'Requests',
      subtitle: 'Pending incoming payment requests',
      destination: HomeSearchDestination.requestsInbox,
    ),
    HomeSearchHit(
      title: 'Transactions',
      subtitle: 'History and receipts',
      destination: HomeSearchDestination.transactions,
    ),
    HomeSearchHit(
      title: 'Scan',
      subtitle: 'Scan a payment QR code',
      destination: HomeSearchDestination.scan,
    ),
    HomeSearchHit(
      title: 'Wallet',
      subtitle: 'Linked wallets',
      destination: HomeSearchDestination.wallet,
    ),
    HomeSearchHit(
      title: 'Settings',
      subtitle: 'Biometrics and sign out',
      destination: HomeSearchDestination.settings,
    ),
  ];
}
