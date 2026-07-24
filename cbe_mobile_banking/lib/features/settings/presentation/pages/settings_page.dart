import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_event.dart';
import 'package:cbe_mobile_banking/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsBloc>()..add(const SettingsStarted()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoaded && state.logoutRequested) {
            context.read<AuthSessionBloc>().add(const AuthSessionLoggedOut());
          }
        },
        builder: (context, state) {
          if (state is! SettingsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Biometric login'),
                value: state.biometricsEnabled,
                onChanged: (_) => context
                    .read<SettingsBloc>()
                    .add(const SettingsBiometricsToggled()),
              ),
              ListTile(
                title: const Text('Language'),
                subtitle: Text(state.maskedLanguage),
              ),
              const ListTile(
                title: Text('Security'),
                subtitle: Text('PIN & session controls (mock)'),
              ),
              ListTile(
                title: const Text('Log out'),
                leading: const Icon(Icons.logout),
                onTap: () => context
                    .read<SettingsBloc>()
                    .add(const SettingsLogoutRequested()),
              ),
            ],
          );
        },
      ),
    );
  }
}
