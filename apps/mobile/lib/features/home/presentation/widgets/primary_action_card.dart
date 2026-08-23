import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// One of the two equal-weight "I LOST SOMETHING" / "I FOUND SOMETHING"
/// actions on Home. Both variants share this widget so their sizing and
/// emphasis stay identical — only the accent color differs by context.
class PrimaryActionCard extends StatelessWidget {
  const PrimaryActionCard({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.tintColor,
    required this.onTap,
  });

  final String label;
  final String description;
  final IconData icon;
  final Color accentColor;
  final Color tintColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(AppSpacing.radiusCard);

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: accentColor.withValues(alpha: 0.14),
          child: Container(
            constraints: const BoxConstraints(minHeight: 148),
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: BoxDecoration(
              color: tintColor,
              borderRadius: radius,
              border: Border.all(color: accentColor.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accentColor, size: 20),
                ),
                const Spacer(),
                Text(
                  label,
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
