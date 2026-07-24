import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Brand theme from CBE redesign PDF (plum + peach).
abstract final class AppTheme {
  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
    );
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.plum,
      brightness: Brightness.dark,
      primary: AppColors.peach,
      onPrimary: AppColors.plum,
      surface: AppColors.plum,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.plumDeep,
      textTheme: AppTypography.darkTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.plumDeep,
        foregroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.peach,
          foregroundColor: AppColors.plum,
          shape: const StadiumBorder(),
          minimumSize: const Size.fromHeight(52),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.peach,
        foregroundColor: AppColors.plum,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.plum,
        indicatorColor: AppColors.peach.withValues(alpha: 0.18),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        height: 68,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.plum,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.peach),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.peach),
        ),
      ),
    );
  }
}
