import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/friendly_date.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/report_review_row.dart';
import '../../models/lost_report_draft.dart';

class LostReviewStep extends StatelessWidget {
  const LostReviewStep({super.key, required this.draft, required this.onEditStep});

  final LostReportDraft draft;
  final ValueChanged<int> onEditStep;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final photoBytes = draft.photoBytes;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s8),
          Text('Review your report', style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'Make sure this looks right before you submit.',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s24),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (photoBytes != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                    child: Image.memory(photoBytes, height: 140, width: double.infinity, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                ],
                ReportReviewRow(
                  label: 'Category',
                  value: draft.category ?? '—',
                  onEdit: () => onEditStep(0),
                ),
                const ReportReviewDivider(),
                ReportReviewRow(
                  label: 'Photo',
                  value: photoBytes != null ? 'Added' : 'Not added',
                  onEdit: () => onEditStep(1),
                ),
                const ReportReviewDivider(),
                ReportReviewRow(
                  label: 'Description',
                  value: draft.hasDescription ? draft.description : '—',
                  onEdit: () => onEditStep(2),
                ),
                const ReportReviewDivider(),
                ReportReviewRow(
                  label: 'Location',
                  value: draft.locationLabel ?? '—',
                  onEdit: () => onEditStep(3),
                ),
                const ReportReviewDivider(),
                ReportReviewRow(
                  label: 'Date & time',
                  value: draft.occurredAt == null
                      ? '—'
                      : friendlyDate(draft.occurredAt!, includeTime: true),
                  onEdit: () => onEditStep(3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
