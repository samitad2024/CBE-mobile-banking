import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// PDF-style search chrome ("Search anything" + QR leading icon).
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    this.onChanged,
    this.onQrTap,
    this.hint = 'Search anything',
    super.key,
  });

  final ValueChanged<String>? onChanged;
  final VoidCallback? onQrTap;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.muted),
        prefixIcon: IconButton(
          onPressed: onQrTap,
          icon: const Icon(Icons.qr_code_scanner, color: AppColors.peach),
        ),
        filled: true,
        fillColor: AppColors.plum.withValues(alpha: 0.55),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: AppColors.peach.withValues(alpha: 0.45)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: AppColors.peach.withValues(alpha: 0.45)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.peach),
        ),
      ),
    );
  }
}
