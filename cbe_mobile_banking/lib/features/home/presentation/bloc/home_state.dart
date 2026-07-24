import 'package:cbe_mobile_banking/features/home/domain/entities/home_dashboard_entity.dart';
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
  });

  final HomeDashboardEntity dashboard;
  final bool isBalanceVisible;

  HomeLoaded copyWith({
    HomeDashboardEntity? dashboard,
    bool? isBalanceVisible,
  }) {
    return HomeLoaded(
      dashboard: dashboard ?? this.dashboard,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
    );
  }

  @override
  List<Object?> get props => [dashboard, isBalanceVisible];
}

final class HomeFailureState extends HomeState {
  const HomeFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
