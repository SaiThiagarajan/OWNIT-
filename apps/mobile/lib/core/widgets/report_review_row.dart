import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// A label/value row with a trailing "Edit >" action, used on the Lost and
/// Found review steps so each section can be corrected without restarting
/// the flow.
class ReportReviewRow extends StatelessWidget {
  const ReportReviewRow({super.key, required this.label, required this.value, required this.onEdit});

  final String label;
  final String value;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.labelMedium?.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.s4),
                Text(value, style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary)),
              ],
            ),
          ),
          Semantics(
            button: true,
            label: 'Edit $label',
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
                child: Text(
                  'Edit >',
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
    );
  }
}

class ReportReviewDivider extends StatelessWidget {
  const ReportReviewDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.border, height: AppSpacing.s16);
  }
}
