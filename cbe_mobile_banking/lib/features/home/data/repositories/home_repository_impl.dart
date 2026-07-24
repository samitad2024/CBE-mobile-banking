import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/home/data/datasources/home_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:cbe_mobile_banking/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required this._mockDataSource});

  final HomeMockDataSource _mockDataSource;

  @override
  Future<({Failure? failure, HomeDashboardEntity? dashboard})>
      getDashboard() async {
    try {
      final dashboard = await _mockDataSource.fetchDashboard();
      return (failure: null, dashboard: dashboard);
    } on Exception {
      return (failure: const UnexpectedFailure(), dashboard: null);
    }
  }
}
