import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Semantic status pill. Colors follow the spec's context rules: lost is
/// coral, found/matched/AI is teal, pending/neutral is muted, and rejected
/// is the error color — never a bare color swatch with no text.
enum StatusBadgeVariant { lost, found, matched, pending, verified, rejected, neutral }

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.variant});

  final String label;
  final StatusBadgeVariant variant;

  ({Color background, Color foreground}) get _colors => switch (variant) {
        StatusBadgeVariant.lost => (
            background: AppColors.lostTint,
            foreground: AppColors.lostCoral,
          ),
        StatusBadgeVariant.found => (
            background: AppColors.foundTint,
            foreground: AppColors.foundTeal,
          ),
        StatusBadgeVariant.matched => (
            background: AppColors.foundTint,
            foreground: AppColors.foundTeal,
          ),
        StatusBadgeVariant.verified => (
            background: AppColors.foundTint,
            foreground: AppColors.foundTeal,
          ),
        StatusBadgeVariant.rejected => (
            background: AppColors.surfaceElevated,
            foreground: AppColors.error,
          ),
        StatusBadgeVariant.pending => (
            background: AppColors.surfaceElevated,
            foreground: AppColors.textSecondary,
          ),
        StatusBadgeVariant.neutral => (
            background: AppColors.surfaceElevated,
            foreground: AppColors.textSecondary,
          ),
      };

  @override
  Widget build(BuildContext context) {
    final colors = _colors;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: '$label status',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s4),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: colors.foreground, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.s8),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: colors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
