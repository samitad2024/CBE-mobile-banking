import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/core/constants/app_constants.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_event.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_event.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Login placeholder aligned to PDF (PIN + biometrics). Pixel UI later.
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
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
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
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    'COMMERCIAL BANK OF ETHIOPIA',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.peach,
                          fontWeight: FontWeight.w700,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Insert Pin or Use Biometrics to Log In',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _pinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: AppConstants.pinLength,
                    decoration: const InputDecoration(
                      labelText: 'PIN',
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppPrimaryButton(
                    label: loading ? 'Please wait…' : 'Log In',
                    onPressed: loading
                        ? null
                        : () {
                            context.read<AuthBloc>().add(
                                  AuthPinSubmitted(_pinController.text),
                                );
                          },
                  ),
                  const SizedBox(height: 24),
                  IconButton(
                    iconSize: 56,
                    color: AppColors.peach,
                    onPressed: loading
                        ? null
                        : () {
                            context.read<AuthBloc>().add(
                                  const AuthBiometricRequested(),
                                );
                          },
                    icon: const Icon(Icons.fingerprint),
                  ),
                  Text(
                    'Mock PIN: ${AppConstants.mockPin}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.muted,
                        ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
