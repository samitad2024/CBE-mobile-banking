import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Branded loading indicator for list/detail screens (Step 12 polish).
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.peach,
            ),
          ),
          if (label != null) ...[
            const SizedBox(height: 14),
            Text(
              label!,
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}
