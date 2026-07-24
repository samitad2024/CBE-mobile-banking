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
  });

  final bool biometricsEnabled;
  final String maskedLanguage;

  SettingsLoaded copyWith({
    bool? biometricsEnabled,
    String? maskedLanguage,
  }) {
    return SettingsLoaded(
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      maskedLanguage: maskedLanguage ?? this.maskedLanguage,
    );
  }

  @override
  List<Object?> get props => [biometricsEnabled, maskedLanguage];
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
  }
}
