import 'package:equatable/equatable.dart';

class AccountSummaryEntity extends Equatable {
  const AccountSummaryEntity({
    required this.customerName,
    required this.accountNumber,
    required this.balanceEtb,
    required this.updatedAt,
  });

  final String customerName;
  final String accountNumber;
  final double balanceEtb;
  final DateTime updatedAt;

  @override
  List<Object?> get props =>
      [customerName, accountNumber, balanceEtb, updatedAt];
}

class RecentRecipientEntity extends Equatable {
  const RecentRecipientEntity({
    required this.initial,
    required this.lastFour,
    required this.fullName,
    required this.accountNumber,
  });

  final String initial;
  final String lastFour;
  final String fullName;
  final String accountNumber;

  @override
  List<Object?> get props => [initial, lastFour, fullName, accountNumber];
}

class HomeDashboardEntity extends Equatable {
  const HomeDashboardEntity({
    required this.account,
    required this.recentRecipients,
    required this.pendingRequestCount,
  });

  final AccountSummaryEntity account;
  final List<RecentRecipientEntity> recentRecipients;
  final int pendingRequestCount;

  @override
  List<Object?> get props => [account, recentRecipients, pendingRequestCount];
}
