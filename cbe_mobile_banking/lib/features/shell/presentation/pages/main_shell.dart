import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// PDF bottom nav shell: Home · Scan · Wallet · Settings.
class MainShell extends StatelessWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.plumDeep,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        backgroundColor: AppColors.plum,
        indicatorColor: AppColors.peach.withValues(alpha: 0.18),
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        height: 68,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppColors.muted),
            selectedIcon: Icon(Icons.home, color: AppColors.peach),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner, color: AppColors.muted),
            selectedIcon: Icon(Icons.qr_code_scanner, color: AppColors.peach),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined, color: AppColors.muted),
            selectedIcon:
                Icon(Icons.account_balance_wallet, color: AppColors.peach),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: AppColors.muted),
            selectedIcon: Icon(Icons.settings, color: AppColors.peach),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
