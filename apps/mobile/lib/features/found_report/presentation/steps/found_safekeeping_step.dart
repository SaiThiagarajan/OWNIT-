import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../models/found_report_draft.dart';

class FoundSafekeepingStep extends StatelessWidget {
  const FoundSafekeepingStep({super.key, required this.draft, required this.onChanged});

  final FoundReportDraft draft;
  final VoidCallback onChanged;

  static const _options = [
    (
      value: SafekeepingOption.keepingSafely,
      label: "I'm keeping it",
      icon: Icons.shield_outlined,
    ),
    (
      value: SafekeepingOption.frontDesk,
      label: 'Handed to a front desk',
      icon: Icons.apartment_outlined,
    ),
    (
      value: SafekeepingOption.security,
      label: 'Handed to security',
      icon: Icons.local_police_outlined,
    ),
    (value: SafekeepingOption.other, label: 'Other', icon: Icons.more_horiz),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s8),
          Text('Where is the item now?', style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.s8),
          Text(
            "This helps the owner know where to find it.",
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s24),
          ..._options.map((option) {
            final selected = draft.safekeeping == option.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s12),
              child: Semantics(
                button: true,
                selected: selected,
                label: option.label,
                child: InkWell(
                  onTap: () {
                    draft.safekeeping = option.value;
                    onChanged();
                  },
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: AppSpacing.minTapTarget),
                    padding: const EdgeInsets.all(AppSpacing.cardPadding),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.orange.withValues(alpha: 0.1) : AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                      border: Border.all(color: selected ? AppColors.orange : AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          option.icon,
                          color: selected ? AppColors.orange : AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Expanded(
                          child: Text(
                            option.label,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                        Icon(
                          selected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: selected ? AppColors.orange : AppColors.textTertiary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
