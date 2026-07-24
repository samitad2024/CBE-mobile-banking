import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Typography skeleton aligned to the redesign (sans UI + soft display titles).
abstract final class AppTypography {
  static TextTheme darkTextTheme(TextTheme base) {
    return base
        .apply(
          bodyColor: AppColors.white,
          displayColor: AppColors.peach,
        )
        .copyWith(
          headlineSmall: base.headlineSmall?.copyWith(
            color: AppColors.peach,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: base.titleMedium?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: base.bodyMedium?.copyWith(color: AppColors.muted),
          labelLarge: base.labelLarge?.copyWith(
            color: AppColors.plum,
            fontWeight: FontWeight.w700,
          ),
        );
  }
}
