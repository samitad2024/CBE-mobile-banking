import 'package:cbe_mobile_banking/features/home/domain/entities/home_dashboard_entity.dart';

abstract interface class HomeMockDataSource {
  Future<HomeDashboardEntity> fetchDashboard();
}

class HomeMockDataSourceImpl implements HomeMockDataSource {
  @override
  Future<HomeDashboardEntity> fetchDashboard() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return HomeDashboardEntity(
      account: AccountSummaryEntity(
        customerName: 'Girma Belay Terunehe',
        accountNumber: '1000582007601',
        balanceEtb: 100000,
        updatedAt: DateTime(2024, 12, 20, 9, 36),
      ),
      recentRecipients: const [
        RecentRecipientEntity(
          initial: 'M',
          lastFour: '5744',
          fullName: 'Ahmed Abdella Yesuf',
          accountNumber: '1000582007601',
        ),
        RecentRecipientEntity(
          initial: 'D',
          lastFour: '7584',
          fullName: 'Girma Gebre Hiwet',
          accountNumber: '1000465507601',
        ),
        RecentRecipientEntity(
          initial: 'S',
          lastFour: '1323',
          fullName: 'Hiwet Amha Sileshi',
          accountNumber: '1000582007601',
        ),
        RecentRecipientEntity(
          initial: 'W',
          lastFour: '4849',
          fullName: 'Idris Henock Shibeshi',
          accountNumber: '1000582007601',
        ),
        RecentRecipientEntity(
          initial: 'A',
          lastFour: '9636',
          fullName: 'Gebre Abdisa Lemecha',
          accountNumber: '1000582007601',
        ),
      ],
      pendingRequestCount: 3,
    );
  }
}
