import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// A selectable chip, used for category pickers in the lost/found flows.
/// Selection state is communicated with an orange border/tint plus a
/// checkmark — never color alone.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(AppSpacing.radiusControl);

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: AppColors.orange.withValues(alpha: 0.14),
          child: Container(
            constraints: const BoxConstraints(minHeight: AppSpacing.minTapTarget),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s12),
            decoration: BoxDecoration(
              color: selected ? AppColors.orange.withValues(alpha: 0.12) : AppColors.surface,
              borderRadius: radius,
              border: Border.all(color: selected ? AppColors.orange : AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 18,
                    color: selected ? AppColors.orange : AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.s8),
                ],
                Text(
                  label,
                  style: textTheme.labelMedium?.copyWith(
                    color: selected ? AppColors.orange : AppColors.textPrimary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: AppSpacing.s8),
                  const Icon(Icons.check, size: 16, color: AppColors.orange),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
