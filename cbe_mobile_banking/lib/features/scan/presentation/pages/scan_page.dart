import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/app/router/app_router.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/core/widgets/app_secondary_button.dart';
import 'package:cbe_mobile_banking/core/widgets/scan_viewfinder.dart';
import 'package:cbe_mobile_banking/features/scan/presentation/bloc/scan_bloc.dart';
import 'package:cbe_mobile_banking/features/scan/presentation/widgets/camera_scan_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

class _ScanView extends StatefulWidget {
  const _ScanView();

  @override
  State<_ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<_ScanView> {
  var _showSimulate = false;
  var _cameraKey = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.plumDeep,
      appBar: AppBar(
        title: const Text('Scan QR code'),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<ScanBloc, ScanState>(
        listener: (context, state) {
          if (state is ScanFailure) {
            setState(() => _showSimulate = true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final listening = state is ScanListening || state is ScanIdle;
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            child: Column(
              children: [
                Text(
                  switch (state) {
                    ScanIdle() || ScanListening() =>
                      'Align the QR code within the frame',
                    ScanSuccess() => 'QR detected',
                    ScanFailure(:final message) => message,
                  },
                  textAlign: TextAlign.center,
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
                      child: state is ScanSuccess
                          ? ScanViewfinder(
                              child: Column(
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
                              ),
                            )
                          : CameraScanPreview(
                              key: ValueKey(_cameraKey),
                              enabled: listening,
                              onCode: (payload) {
                                context
                                    .read<ScanBloc>()
                                    .add(ScanCodeDetected(payload));
                              },
                              onCameraError: (message) {
                                setState(() => _showSimulate = true);
                                context
                                    .read<ScanBloc>()
                                    .add(ScanFailed(message));
                              },
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (listening && _showSimulate)
                  AppPrimaryButton(
                    label: 'Simulate scan',
                    icon: Icons.qr_code_2,
                    onPressed: () => context.read<ScanBloc>().add(
                          const ScanCodeDetected('CBE|PAY|MOCK|50000'),
                        ),
                  ),
                if (listening && !_showSimulate)
                  const Text(
                    'Point your camera at a CBE payment QR',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                if (state is ScanSuccess) ...[
                  AppPrimaryButton(
                    label: 'Scan again',
                    onPressed: () {
                      setState(() => _cameraKey++);
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
                      context.push(
                        AppRoutes.transfer,
                        extra: state.payload,
                      );
                    },
                  ),
                ],
                if (state is ScanFailure) ...[
                  const SizedBox(height: 12),
                  AppPrimaryButton(
                    label: 'Retry camera',
                    onPressed: () {
                      setState(() {
                        _showSimulate = false;
                        _cameraKey++;
                      });
                      context.read<ScanBloc>()
                        ..add(const ScanReset())
                        ..add(const ScanStarted());
                    },
                  ),
                  const SizedBox(height: 12),
                  AppSecondaryButton(
                    label: 'Simulate scan',
                    onPressed: () => context.read<ScanBloc>().add(
                          const ScanCodeDetected('CBE|PAY|MOCK|50000'),
                        ),
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
