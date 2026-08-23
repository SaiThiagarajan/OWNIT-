import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/confidence_badge.dart';
import '../../../core/widgets/status_badge.dart';
import '../models/mock_report.dart';

/// A clean report-detail view for a public search result. Deliberately
/// shows only coarse location and no contact/identity details — that
/// information stays behind ownership verification, which isn't built yet.
class ReportDetailScreen extends StatelessWidget {
  const ReportDetailScreen({super.key, required this.report});

  final MockReport report;

  void _claim(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Ownership verification is coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accent = report.kind == ReportKind.lost ? AppColors.lostCoral : AppColors.foundTeal;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Report detail'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s16),
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                ),
                child: Icon(report.icon, color: accent, size: 56),
              ),
              const SizedBox(height: AppSpacing.s16),
              Row(
                children: [
                  StatusBadge(label: report.statusLabel, variant: report.statusVariant),
                  if (report.aiConfidence != null) ...[
                    const SizedBox(width: AppSpacing.s8),
                    ConfidenceBadge(percent: report.aiConfidence!, label: 'AI suggested'),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(report.title, style: textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.s8),
              Text(
                report.subtitle,
                style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s24),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(label: 'Category', value: report.category),
                    const Divider(color: AppColors.border, height: AppSpacing.s24),
                    _DetailRow(label: 'Coarse location', value: report.coarseLocation),
                    const Divider(color: AppColors.border, height: AppSpacing.s24),
                    _DetailRow(label: 'Reported', value: report.relativeTime),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(
                'Exact location and contact details are only shared once ownership is verified.',
                style: textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: AppSpacing.s32),
              PrimaryButton(label: 'Claim this item', onPressed: () => _claim(context)),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        Text(value, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
