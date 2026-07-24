import 'package:cbe_mobile_banking/features/home/domain/usecases/get_home_dashboard_usecase.dart';
import 'package:cbe_mobile_banking/features/home/presentation/bloc/home_event.dart';
import 'package:cbe_mobile_banking/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this._getHomeDashboard})
      : super(const HomeInitial()) {
    on<HomeStarted>(_onLoad);
    on<HomeRefreshed>(_onLoad);
    on<HomeBalanceVisibilityToggled>(_onToggleVisibility);
  }

  final GetHomeDashboardUseCase _getHomeDashboard;

  Future<void> _onLoad(HomeEvent event, Emitter<HomeState> emit) async {
    final keepVisible =
        state is HomeLoaded && (state as HomeLoaded).isBalanceVisible;
    emit(const HomeLoading());
    final result = await _getHomeDashboard();
    if (result.failure != null) {
      emit(HomeFailureState(result.failure!.message));
      return;
    }
    emit(
      HomeLoaded(
        dashboard: result.dashboard!,
        isBalanceVisible: keepVisible,
      ),
    );
  }

  void _onToggleVisibility(
    HomeBalanceVisibilityToggled event,
    Emitter<HomeState> emit,
  ) {
    final current = state;
    if (current is HomeLoaded) {
      emit(current.copyWith(isBalanceVisible: !current.isBalanceVisible));
    }
  }
}
