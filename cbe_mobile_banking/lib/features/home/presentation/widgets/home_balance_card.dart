import 'dart:math' as math;

import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/utils/account_masker.dart';
import 'package:cbe_mobile_banking/core/utils/money_formatter.dart';
import 'package:cbe_mobile_banking/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:flutter/material.dart';

/// Peach balance card with guilloche pattern (PDF p.2).
class HomeBalanceCard extends StatelessWidget {
  const HomeBalanceCard({
    required this.account,
    required this.isBalanceVisible,
    required this.onToggleVisibility,
    super.key,
  });

  final AccountSummaryEntity account;
  final bool isBalanceVisible;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    final balanceText = isBalanceVisible
        ? MoneyFormatter.formatEtb(account.balanceEtb)
        : '****** ETB';
    final stamp = _formatStamp(account.updatedAt);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.peach,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: _GuillochePainter()),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.customerName,
                  style: const TextStyle(
                    color: AppColors.plum,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AccountMasker.mask(account.accountNumber),
                  style: TextStyle(
                    color: AppColors.plum.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                Semantics(
                  label: isBalanceVisible
                      ? 'Balance $balanceText'
                      : 'Balance hidden',
                  child: Text(
                    balanceText,
                    style: const TextStyle(
                      color: AppColors.plum,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        stamp,
                        style: TextStyle(
                          color: AppColors.plum.withValues(alpha: 0.8),
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ),
                    Material(
                      color: AppColors.plum,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: onToggleVisibility,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isBalanceVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 18,
                                color: AppColors.peach,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isBalanceVisible ? 'Hide' : 'Show',
                                style: const TextStyle(
                                  color: AppColors.peach,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatStamp(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}\n$h : $m';
  }
}

class _GuillochePainter extends CustomPainter {
  const _GuillochePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.plum.withValues(alpha: 0.09)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width * 0.78, size.height * 0.42);
    final maxR = size.shortestSide * 0.55;

    for (var ring = 1; ring <= 7; ring++) {
      final r = maxR * (ring / 7);
      canvas.drawCircle(center, r, paint);
    }

    final petal = Path();
    for (var i = 0; i <= 180; i++) {
      final t = i / 180 * math.pi * 2;
      final r = maxR *
          (0.35 +
              0.22 * math.sin(6 * t) +
              0.08 * math.cos(12 * t));
      final p = Offset(
        center.dx + r * math.cos(t),
        center.dy + r * math.sin(t),
      );
      if (i == 0) {
        petal.moveTo(p.dx, p.dy);
      } else {
        petal.lineTo(p.dx, p.dy);
      }
    }
    petal.close();
    canvas.drawPath(petal, paint);

    final waves = Path();
    for (var wave = 0; wave < 4; wave++) {
      final yBase = size.height * (0.55 + wave * 0.1);
      waves.moveTo(0, yBase);
      for (var x = 0.0; x <= size.width; x += 3) {
        final y = yBase +
            math.sin((x / size.width) * math.pi * 4 + wave) * 8 +
            math.cos((x / size.width) * math.pi * 7) * 3;
        waves.lineTo(x, y);
      }
    }
    canvas.drawPath(waves, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
