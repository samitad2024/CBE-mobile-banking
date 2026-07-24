import 'package:cbe_mobile_banking/features/home/domain/home_search_catalog.dart';
import 'package:cbe_mobile_banking/features/home/domain/usecases/get_home_dashboard_usecase.dart';
import 'package:cbe_mobile_banking/features/home/presentation/bloc/home_event.dart';
import 'package:cbe_mobile_banking/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

EventTransformer<E> _debounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this._getHomeDashboard}) : super(const HomeInitial()) {
    on<HomeStarted>(_onLoad);
    on<HomeRefreshed>(_onLoad);
    on<HomeBalanceVisibilityToggled>(_onToggleVisibility);
    on<HomeSearchChanged>(
      _onSearchChanged,
      transformer: _debounce(const Duration(milliseconds: 300)),
    );
  }

  final GetHomeDashboardUseCase _getHomeDashboard;

  Future<void> _onLoad(HomeEvent event, Emitter<HomeState> emit) async {
    final previous = state;
    final keepVisible =
        previous is HomeLoaded && previous.isBalanceVisible;
    final keepQuery = previous is HomeLoaded ? previous.searchQuery : '';
    emit(const HomeLoading());
    final result = await _getHomeDashboard();
    if (result.failure != null) {
      emit(HomeFailureState(result.failure!.message));
      return;
    }
    final dashboard = result.dashboard!;
    emit(
      HomeLoaded(
        dashboard: dashboard,
        isBalanceVisible: keepVisible,
        searchQuery: keepQuery,
        searchHits: HomeSearchCatalog.query(
          keepQuery,
          dashboard: dashboard,
        ),
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

  void _onSearchChanged(
    HomeSearchChanged event,
    Emitter<HomeState> emit,
  ) {
    final current = state;
    if (current is! HomeLoaded) return;
    final hits = HomeSearchCatalog.query(
      event.query,
      dashboard: current.dashboard,
    );
    emit(
      current.copyWith(
        searchQuery: event.query,
        searchHits: hits,
      ),
    );
  }
}
