import 'package:equatable/equatable.dart';

/// Local search hit for Home "Search anything" (mock v1 — no backend).
enum HomeSearchDestination {
  transfer,
  requestMoney,
  requestsInbox,
  transactions,
  scan,
  wallet,
  settings,
}

class HomeSearchHit extends Equatable {
  const HomeSearchHit({
    required this.title,
    required this.subtitle,
    required this.destination,
  });

  final String title;
  final String subtitle;
  final HomeSearchDestination destination;

  @override
  List<Object?> get props => [title, subtitle, destination];
}
