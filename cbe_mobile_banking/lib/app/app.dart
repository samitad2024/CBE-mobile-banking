import 'package:cbe_mobile_banking/app/router/app_router.dart';
import 'package:cbe_mobile_banking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Root application widget. Feature screens are added later.
class CbeMobileBankingApp extends StatelessWidget {
  const CbeMobileBankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CBE Mobile Banking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: AppRouter.router,
    );
  }
}
