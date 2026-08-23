import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Back button + step-progress bar shared by the Lost and Found report
/// flows. [accentColor] lets each flow tint the progress bar with its own
/// context color (coral for Lost, teal for Found) without duplicating this
/// chrome per flow.
class ReportFlowHeader extends StatelessWidget {
  const ReportFlowHeader({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.onBack,
    required this.onClose,
    this.accentColor = AppColors.orange,
  });

  final int step;
  final int totalSteps;
  final VoidCallback onBack;
  final VoidCallback onClose;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s8,
        AppSpacing.s8,
        AppSpacing.s8,
        AppSpacing.s8,
      ),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: 'Back',
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
              child: const SizedBox(
                width: AppSpacing.minTapTarget,
                height: AppSpacing.minTapTarget,
                child: Icon(Icons.arrow_back, color: AppColors.textPrimary),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s4),
          Expanded(
            child: Semantics(
              label: 'Step ${step + 1} of $totalSteps',
              child: Row(
                children: List.generate(totalSteps, (index) {
                  final active = index <= step;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : AppSpacing.s4),
                      height: 4,
                      decoration: BoxDecoration(
                        color: active ? accentColor : AppColors.border,
                        borderRadius: BorderRadius.circular(AppSpacing.s4),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s4),
          Semantics(
            button: true,
            label: 'Close',
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
              child: const SizedBox(
                width: AppSpacing.minTapTarget,
                height: AppSpacing.minTapTarget,
                child: Icon(Icons.close, color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
