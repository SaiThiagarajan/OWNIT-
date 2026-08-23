import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Lower-emphasis companion to [PrimaryButton]: no fill, just a border and
/// text, for secondary actions like "Skip" or "Cancel". Orange is reserved
/// for the pressed/focused border, same as [PrimaryButton].
class SecondaryButton extends StatefulWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool fullWidth;

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final borderColor = !_enabled
        ? AppColors.border.withValues(alpha: 0.5)
        : _pressed
            ? AppColors.orange
            : AppColors.border;

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      child: SizedBox(
        width: widget.fullWidth ? double.infinity : null,
        height: AppSpacing.controlHeight,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          child: InkWell(
            onTap: _enabled ? widget.onPressed : null,
            onHighlightChanged: _setPressed,
            focusColor: AppColors.orange.withValues(alpha: 0.1),
            hoverColor: AppColors.orange.withValues(alpha: 0.06),
            splashColor: AppColors.orange.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                border: Border.all(color: borderColor),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.leadingIcon != null) ...[
                      Icon(
                        widget.leadingIcon,
                        size: 20,
                        color: _enabled ? AppColors.textSecondary : AppColors.textTertiary,
                      ),
                      const SizedBox(width: AppSpacing.s8),
                    ],
                    Text(
                      widget.label,
                      style: textTheme.labelLarge?.copyWith(
                        color: _enabled ? AppColors.textSecondary : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
