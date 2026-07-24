import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/core/widgets/app_secondary_button.dart';
import 'package:cbe_mobile_banking/core/widgets/scan_viewfinder.dart';
import 'package:cbe_mobile_banking/features/scan/presentation/bloc/scan_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ScanBloc>()..add(const ScanStarted()),
      child: const _ScanView(),
    );
  }
}

class _ScanView extends StatelessWidget {
  const _ScanView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.plumDeep,
      appBar: AppBar(
        title: const Text('Scan QR code'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<ScanBloc, ScanState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            child: Column(
              children: [
                Text(
                  switch (state) {
                    ScanIdle() || ScanListening() =>
                      'Align the QR code within the frame',
                    ScanSuccess() => 'QR detected',
                  },
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: ScanViewfinder(
                        child: state is ScanSuccess
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.peach,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      state.payload,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (state is ScanListening || state is ScanIdle)
                  AppPrimaryButton(
                    label: 'Simulate scan',
                    icon: Icons.qr_code_2,
                    onPressed: () => context.read<ScanBloc>().add(
                          const ScanMockCodeDetected('CBE|PAY|MOCK|50000'),
                        ),
                  ),
                if (state is ScanSuccess) ...[
                  AppPrimaryButton(
                    label: 'Scan again',
                    onPressed: () {
                      context.read<ScanBloc>()
                        ..add(const ScanReset())
                        ..add(const ScanStarted());
                    },
                  ),
                  const SizedBox(height: 12),
                  AppSecondaryButton(
                    label: 'Use for transfer',
                    icon: Icons.north_east,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Payload ready: ${state.payload}'),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
