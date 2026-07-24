import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/core/constants/app_constants.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_event.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_event.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_state.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/widgets/biometric_button.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/widgets/cbe_brand_header.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/widgets/pin_dots_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Login screen aligned to PDF p.1 (PIN dots + biometric).
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  String _pin = '';

  void _submit(BuildContext context) {
    if (_pin.length != AppConstants.pinLength) return;
    context.read<AuthBloc>().add(AuthPinSubmitted(_pin));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.read<AuthSessionBloc>().add(
                AuthSessionLoggedIn(state.session),
              );
        }
        if (state is AuthFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final loading = state is AuthLoading;
        final canSubmit = !loading && _pin.length == AppConstants.pinLength;
        return Scaffold(
          backgroundColor: AppColors.plumDeep,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  const CbeBrandHeader(),
                  const Spacer(flex: 2),
                  Text(
                    'Insert Pin or Use Biometrics to Log In',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 28),
                  PinDotsField(
                    enabled: !loading,
                    onChanged: (pin) => setState(() => _pin = pin),
                  ),
                  const SizedBox(height: 28),
                  AppPrimaryButton(
                    label: loading ? 'Please wait…' : 'Log In',
                    onPressed: canSubmit ? () => _submit(context) : null,
                  ),
                  const Spacer(),
                  BiometricButton(
                    enabled: !loading,
                    onPressed: () => context.read<AuthBloc>().add(
                          const AuthBiometricRequested(),
                        ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
