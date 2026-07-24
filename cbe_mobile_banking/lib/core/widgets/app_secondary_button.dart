import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Outlined / secondary CTA matching PDF inactive Transfer/Request buttons.
class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.peach,
          side: const BorderSide(color: AppColors.peach),
          shape: const StadiumBorder(),
        ),
        child: Text(label),
      ),
    );
  }
}
