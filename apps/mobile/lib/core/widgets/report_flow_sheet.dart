import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// The shared chrome for the Lost/Found report flows: a dark elevated
/// surface with the same 28px top radius and drag handle as
/// [AppBottomSheet], sitting just below a thin peek of the plain
/// background so it reads as a sheet even though — unlike a literal modal
/// bottom sheet — it's a normal full-screen route. That keeps Android
/// system-back handling simple and correct (a real modal sheet route
/// would dismiss entirely on first back-press, which is wrong here: back
/// must step through the wizard one question at a time before it can
/// close the flow).
class ReportFlowSheet extends StatelessWidget {
  const ReportFlowSheet({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.s12),
        Expanded(
          child: Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusBottomSheet)),
            ),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.s12),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(AppSpacing.s4),
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
