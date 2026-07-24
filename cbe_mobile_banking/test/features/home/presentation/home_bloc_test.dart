import 'package:cbe_mobile_banking/core/error/failures.dart';
import 'package:cbe_mobile_banking/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:cbe_mobile_banking/features/home/domain/repositories/home_repository.dart';
import 'package:cbe_mobile_banking/features/home/domain/usecases/get_home_dashboard_usecase.dart';
import 'package:cbe_mobile_banking/features/home/presentation/bloc/home_bloc.dart';
import 'package:cbe_mobile_banking/features/home/presentation/bloc/home_event.dart';
import 'package:cbe_mobile_banking/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHomeRepository implements HomeRepository {
  @override
  Future<({Failure? failure, HomeDashboardEntity? dashboard})>
      getDashboard() async {
    return (
      failure: null,
      dashboard: HomeDashboardEntity(
        account: AccountSummaryEntity(
          customerName: 'Test',
          accountNumber: '1000',
          balanceEtb: 100,
          updatedAt: DateTime(2024),
        ),
        recentRecipients: const [],
        pendingRequestCount: 0,
      ),
    );
  }
}

void main() {
  late HomeBloc bloc;

  setUp(() {
    bloc = HomeBloc(getHomeDashboard: GetHomeDashboardUseCase(_FakeHomeRepository()));
  });

  tearDown(() async => bloc.close());

  test('loads dashboard', () async {
    final states = <HomeState>[];
    final sub = bloc.stream.listen(states.add);
    bloc.add(const HomeStarted());
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await sub.cancel();
    expect(states.whereType<HomeLoaded>(), isNotEmpty);
  });

  test('toggles balance visibility', () async {
    bloc.add(const HomeStarted());
    await Future<void>.delayed(const Duration(milliseconds: 50));
    bloc.add(const HomeBalanceVisibilityToggled());
    await Future<void>.delayed(const Duration(milliseconds: 20));
    final loaded = bloc.state as HomeLoaded;
    expect(loaded.isBalanceVisible, isTrue);
  });
}
