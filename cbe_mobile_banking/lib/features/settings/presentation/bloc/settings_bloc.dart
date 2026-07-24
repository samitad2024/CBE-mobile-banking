import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

final class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

final class SettingsBiometricsToggled extends SettingsEvent {
  const SettingsBiometricsToggled();
}

final class SettingsLogoutRequested extends SettingsEvent {
  const SettingsLogoutRequested();
}

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

final class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

final class SettingsLoaded extends SettingsState {
  const SettingsLoaded({
    this.biometricsEnabled = true,
    this.maskedLanguage = 'English',
    this.logoutRequested = false,
  });

  final bool biometricsEnabled;
  final String maskedLanguage;
  final bool logoutRequested;

  SettingsLoaded copyWith({
    bool? biometricsEnabled,
    String? maskedLanguage,
    bool? logoutRequested,
  }) {
    return SettingsLoaded(
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      maskedLanguage: maskedLanguage ?? this.maskedLanguage,
      logoutRequested: logoutRequested ?? this.logoutRequested,
    );
  }

  @override
  List<Object?> get props =>
      [biometricsEnabled, maskedLanguage, logoutRequested];
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsInitial()) {
    on<SettingsStarted>(
      (event, emit) => emit(const SettingsLoaded()),
    );
    on<SettingsBiometricsToggled>((event, emit) {
      final current = state;
      if (current is SettingsLoaded) {
        emit(
          current.copyWith(biometricsEnabled: !current.biometricsEnabled),
        );
      }
    });
    on<SettingsLogoutRequested>((event, emit) {
      final current = state;
      if (current is SettingsLoaded) {
        emit(current.copyWith(logoutRequested: true));
      }
    });
  }
}
