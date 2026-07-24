import 'package:cbe_mobile_banking/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SettingsBloc bloc;

  setUp(() => bloc = SettingsBloc());
  tearDown(() async => bloc.close());

  test('started loads defaults', () async {
    bloc.add(const SettingsStarted());
    await Future<void>.delayed(const Duration(milliseconds: 10));
    final state = bloc.state;
    expect(state, isA<SettingsLoaded>());
    expect((state as SettingsLoaded).biometricsEnabled, isTrue);
    expect(state.logoutRequested, isFalse);
  });

  test('toggles biometrics', () async {
    bloc
      ..add(const SettingsStarted())
      ..add(const SettingsBiometricsToggled());
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect((bloc.state as SettingsLoaded).biometricsEnabled, isFalse);
  });

  test('logout sets logoutRequested flag', () async {
    bloc
      ..add(const SettingsStarted())
      ..add(const SettingsLogoutRequested());
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect((bloc.state as SettingsLoaded).logoutRequested, isTrue);
  });
}
