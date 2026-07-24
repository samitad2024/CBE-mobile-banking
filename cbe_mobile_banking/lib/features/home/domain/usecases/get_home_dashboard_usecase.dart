import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:cbe_mobile_banking/features/home/domain/repositories/home_repository.dart';

class GetHomeDashboardUseCase {
  GetHomeDashboardUseCase(this._repository);

  final HomeRepository _repository;

  Future<({Failure? failure, HomeDashboardEntity? dashboard})> call() {
    return _repository.getDashboard();
  }
}
