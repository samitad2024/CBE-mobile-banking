import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
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
      appBar: AppBar(title: const Text('Scan')),
      body: BlocBuilder<ScanBloc, ScanState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.qr_code_scanner, size: 96),
                const SizedBox(height: 16),
                Text(
                  switch (state) {
                    ScanIdle() => 'Ready',
                    ScanListening() => 'Listening for QR (mock)',
                    ScanSuccess(:final payload) => 'Scanned: $payload',
                  },
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (state is ScanListening)
                  AppPrimaryButton(
                    label: 'Simulate Scan',
                    onPressed: () => context.read<ScanBloc>().add(
                          const ScanMockCodeDetected('CBE|PAY|MOCK|50000'),
                        ),
                  ),
                if (state is ScanSuccess)
                  AppPrimaryButton(
                    label: 'Scan Again',
                    onPressed: () {
                      context.read<ScanBloc>()
                        ..add(const ScanReset())
                        ..add(const ScanStarted());
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
