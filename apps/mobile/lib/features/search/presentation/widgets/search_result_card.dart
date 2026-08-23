import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/confidence_badge.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../models/mock_report.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({super.key, required this.report, required this.onTap});

  final MockReport report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accent = report.kind == ReportKind.lost ? AppColors.lostCoral : AppColors.foundTeal;

    return AppCard(
      onTap: onTap,
      semanticLabel: '${report.title}, ${report.statusLabel.toLowerCase()}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 96,
            width: double.infinity,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
            ),
            child: Icon(report.icon, color: accent, size: 32),
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(report.title, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.s4),
          Text(
            report.subtitle,
            style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            report.relativeTime,
            style: textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: AppSpacing.s12),
          Row(
            children: [
              StatusBadge(label: report.statusLabel, variant: report.statusVariant),
              if (report.aiConfidence != null) ...[
                const SizedBox(width: AppSpacing.s8),
                ConfidenceBadge(percent: report.aiConfidence!, label: 'AI suggested'),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
