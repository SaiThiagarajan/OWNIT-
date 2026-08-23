import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// The base surface for grouped content: elevated dark background, subtle
/// border, 20px radius, 16px internal padding. Wrap [onTap] to make the
/// whole card an accessible tap target.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.backgroundColor = AppColors.surfaceElevated,
    this.borderColor = AppColors.border,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSpacing.radiusCard);
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius,
        border: Border.all(color: borderColor),
      ),
      child: child,
    );

    if (onTap == null) {
      return semanticLabel != null
          ? Semantics(label: semanticLabel, container: true, child: content)
          : content;
    }

    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: AppColors.orange.withValues(alpha: 0.12),
          highlightColor: AppColors.orange.withValues(alpha: 0.06),
          child: content,
        ),
      ),
    );
  }
}
