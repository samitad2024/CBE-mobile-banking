import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// CBE brand lockup for login (PDF p.1). Spelling corrected to COMMERCIAL.
class CbeBrandHeader extends StatelessWidget {
  const CbeBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomPaint(
          size: Size(88, 88),
          painter: _CbeMarkPainter(),
        ),
        const SizedBox(height: 16),
        const Text(
          'የኢትዮጵያ ንግድ ባንክ',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.peach,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'COMMERCIAL BANK OF ETHIOPIA',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.peach,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _CbeMarkPainter extends CustomPainter {
  const _CbeMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.peach
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    for (var i = 1; i <= 4; i++) {
      canvas.drawCircle(center, size.shortestSide * (0.18 + i * 0.08), paint);
    }
    final fill = Paint()..color = AppColors.peach.withValues(alpha: 0.15);
    canvas.drawCircle(center, size.shortestSide * 0.22, fill);

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'CBE',
        style: TextStyle(
          color: AppColors.peach,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
