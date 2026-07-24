import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Shared primary CTA — full UI kit expands later.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
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
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.peach,
          foregroundColor: AppColors.plum,
          shape: const StadiumBorder(),
        ),
        child: Text(label),
      ),
    );
  }
}
