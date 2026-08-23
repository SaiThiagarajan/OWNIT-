import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// A compact inline error + retry row, for when a full-screen [ErrorState]
/// would be too heavy — e.g. a failed submission at the bottom of a form,
/// where the user's entered data must stay visible and intact.
class InlineErrorBanner extends StatelessWidget {
  const InlineErrorBanner({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.s12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, size: 18, color: AppColors.error),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: Text(message, style: textTheme.bodySmall?.copyWith(color: AppColors.error)),
            ),
            const SizedBox(width: AppSpacing.s8),
            Semantics(
              button: true,
              label: 'Retry',
              child: InkWell(
                onTap: onRetry,
                borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
                  child: Text(
                    'Retry',
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
