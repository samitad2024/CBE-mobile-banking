import 'package:cbe_mobile_banking/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:cbe_mobile_banking/features/home/domain/entities/home_search_hit.dart';
import 'package:equatable/equatable.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.dashboard,
    this.isBalanceVisible = false,
    this.searchQuery = '',
    this.searchHits = const [],
  });

  final HomeDashboardEntity dashboard;
  final bool isBalanceVisible;
  final String searchQuery;
  final List<HomeSearchHit> searchHits;

  HomeLoaded copyWith({
    HomeDashboardEntity? dashboard,
    bool? isBalanceVisible,
    String? searchQuery,
    List<HomeSearchHit>? searchHits,
  }) {
    return HomeLoaded(
      dashboard: dashboard ?? this.dashboard,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
      searchQuery: searchQuery ?? this.searchQuery,
      searchHits: searchHits ?? this.searchHits,
    );
  }

  @override
  List<Object?> get props =>
      [dashboard, isBalanceVisible, searchQuery, searchHits];
}

final class HomeFailureState extends HomeState {
  const HomeFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
