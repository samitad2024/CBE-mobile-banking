import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Fingerprint control with concentric glow (PDF p.1).
class BiometricButton extends StatelessWidget {
  const BiometricButton({
    required this.onPressed,
    this.enabled = true,
    super.key,
  });

  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Use biometrics to log in',
      child: InkWell(
        onTap: enabled ? onPressed : null,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 140,
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              for (var i = 3; i >= 1; i--)
                Container(
                  width: 56.0 + i * 28,
                  height: 56.0 + i * 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.plumAccent.withValues(alpha: 0.25 / i),
                      width: 2,
                    ),
                  ),
                ),
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.peach,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.fingerprint,
                  size: 40,
                  color: enabled ? AppColors.plum : AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
