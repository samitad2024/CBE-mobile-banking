import 'dart:math' as math;

import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// QR viewfinder chrome shared by Scan tab and Request scan sheet (PDF p.9).
class ScanViewfinder extends StatelessWidget {
  const ScanViewfinder({
    this.child,
    super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
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
            if (child != null) child!,
            if (child == null)
              Icon(
                Icons.qr_code_scanner,
                size: 72,
                color: AppColors.peach.withValues(alpha: 0.7),
              ),
            Positioned(top: 16, left: 16, child: _corner()),
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
