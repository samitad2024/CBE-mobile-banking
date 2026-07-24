import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/home/domain/entities/home_dashboard_entity.dart';

abstract interface class HomeRepository {
  Future<({Failure? failure, HomeDashboardEntity? dashboard})> getDashboard();
}
