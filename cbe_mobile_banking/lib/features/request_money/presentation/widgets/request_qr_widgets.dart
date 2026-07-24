import 'dart:math' as math;

import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Decorative QR placeholder rendered from payload bits (no camera package).
class MockQrPreview extends StatelessWidget {
  const MockQrPreview({
    required this.payload,
    this.size = 180,
    super.key,
  });

  final String payload;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'QR code for payment request',
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: CustomPaint(
          painter: _QrPainter(payload),
        ),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  _QrPainter(this.payload);

  final String payload;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.plum;
    const modules = 21;
    final cell = size.shortestSide / modules;
    final hash = payload.codeUnits.fold<int>(0, (a, b) => a + b);

    for (var y = 0; y < modules; y++) {
      for (var x = 0; x < modules; x++) {
        final finder = (x < 7 && y < 7) ||
            (x > modules - 8 && y < 7) ||
            (x < 7 && y > modules - 8);
        final bit = ((hash + x * 17 + y * 31) % 3) != 0;
        if (finder || bit) {
          canvas.drawRect(
            Rect.fromLTWH(x * cell, y * cell, cell * 0.92, cell * 0.92),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) =>
      oldDelegate.payload != payload;
}

/// Scan QR bottom sheet chrome (PDF p.9).
class ScanQrSheet extends StatelessWidget {
  const ScanQrSheet({
    required this.onMockDetect,
    super.key,
  });

  final VoidCallback onMockDetect;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.muted.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Scan QR code',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.plumDeep,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.peach.withValues(alpha: 0.5)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: 72,
                      color: AppColors.peach.withValues(alpha: 0.7),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: _corner(),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Transform.rotate(angle: math.pi / 2, child: _corner()),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Transform.rotate(angle: math.pi, child: _corner()),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Transform.rotate(angle: -math.pi / 2, child: _corner()),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Align the QR code within the frame',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onMockDetect,
                child: const Text('Simulate scan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _corner() {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.peach, width: 3),
          left: BorderSide(color: AppColors.peach, width: 3),
        ),
      ),
    );
  }
}
