import 'package:flutter/material.dart';

import '../../../../core/constants/item_categories.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../models/lost_report_draft.dart';

class LostCategoryStep extends StatelessWidget {
  const LostCategoryStep({super.key, required this.draft, required this.onChanged});

  final LostReportDraft draft;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s8),
          Text('What did you lose?', style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'Pick the closest category.',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s24),
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: kItemCategories.map((category) {
              return CategoryChip(
                label: category.label,
                icon: category.icon,
                selected: draft.category == category.label,
                onTap: () {
                  draft.category = category.label;
                  onChanged();
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
