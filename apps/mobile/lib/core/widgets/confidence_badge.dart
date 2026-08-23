import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// A teal pill showing an AI match/analysis confidence percentage. Used
/// anywhere AI output is surfaced (Found-flow suggestion, AI result,
/// potential match) so the "this is AI, not fact" signal looks consistent.
class ConfidenceBadge extends StatelessWidget {
  const ConfidenceBadge({super.key, required this.percent, this.label});

  final int percent;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final text = label ?? '$percent% confident match';

    return Semantics(
      label: text,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s8),
        decoration: BoxDecoration(
          color: AppColors.foundTint,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.foundTeal.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, size: 14, color: AppColors.foundTeal),
            const SizedBox(width: AppSpacing.s8),
            Text(
              text,
              style: AppTypography.numeral(fontSize: 13, color: AppColors.foundTeal),
            ),
          ],
        ),
      ),
    );
  }
}
