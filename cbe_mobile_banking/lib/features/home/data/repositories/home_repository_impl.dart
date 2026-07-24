import 'package:cbe_mobile_banking/core/error/exceptions.dart';
import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/home/data/datasources/home_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:cbe_mobile_banking/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required this._dataSource});

  final HomeDataSource _dataSource;

  @override
  Future<({Failure? failure, HomeDashboardEntity? dashboard})>
      getDashboard() async {
    try {
      final dashboard = await _dataSource.fetchDashboard();
      return (failure: null, dashboard: dashboard);
    } on NetworkException catch (e) {
      return (failure: NetworkFailure(e.message), dashboard: null);
    } on ServerException catch (e) {
      return (failure: ServerFailure(e.message), dashboard: null);
    } on AuthException catch (e) {
      return (failure: AuthFailure(e.message), dashboard: null);
    } on Exception {
      return (failure: const UnexpectedFailure(), dashboard: null);
    }
  }
}
