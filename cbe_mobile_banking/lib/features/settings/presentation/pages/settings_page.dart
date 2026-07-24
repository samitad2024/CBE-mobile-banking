import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/utils/account_masker.dart';
import 'package:cbe_mobile_banking/core/widgets/app_secondary_button.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_event.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_state.dart';
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
      backgroundColor: AppColors.plumDeep,
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
      ),
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

          final session = context.watch<AuthSessionBloc>().state;
          final name = session is AuthSessionAuthenticated
              ? session.session.customerName
              : 'Guest';
          final account = session is AuthSessionAuthenticated
              ? AccountMasker.mask(session.session.accountNumber)
              : '****';

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.peach,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.plum,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      account,
                      style: TextStyle(
                        color: AppColors.plum.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _SettingsTile(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Biometric login',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Use fingerprint or Face ID at unlock',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                  activeThumbColor: AppColors.plum,
                  activeTrackColor: AppColors.peach,
                  value: state.biometricsEnabled,
                  onChanged: (_) => context
                      .read<SettingsBloc>()
                      .add(const SettingsBiometricsToggled()),
                ),
              ),
              const SizedBox(height: 10),
              _SettingsTile(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Language',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    state.maskedLanguage,
                    style: const TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
                ),
              ),
              const SizedBox(height: 10),
              const _SettingsTile(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Security',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'PIN & session controls (mock)',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                  trailing: Icon(Icons.chevron_right, color: AppColors.muted),
                ),
              ),
              const SizedBox(height: 28),
              AppSecondaryButton(
                label: 'Log out',
                icon: Icons.logout,
                onPressed: () => context
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

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.plum,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
