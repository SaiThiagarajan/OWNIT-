import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// The highest-emphasis button in the design system.
///
/// Resting state is a dark elevated surface with a border — NOT orange.
/// Orange only appears while the button is pressed or focused, matching
/// the spec's rule that orange is reserved for active/pressed/focused
/// states rather than being a default button fill.
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool isLoading;
  final bool fullWidth;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

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
          color: AppColors.surfaceElevated.withValues(alpha: _enabled ? 1 : 0.6),
          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          child: InkWell(
            onTap: _enabled ? widget.onPressed : null,
            onHighlightChanged: _setPressed,
            focusColor: AppColors.orange.withValues(alpha: 0.12),
            hoverColor: AppColors.orange.withValues(alpha: 0.08),
            splashColor: AppColors.orange.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                border: Border.all(color: borderColor, width: _pressed ? 1.5 : 1),
              ),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.orange,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.leadingIcon != null) ...[
                            Icon(widget.leadingIcon, size: 20, color: AppColors.textPrimary),
                            const SizedBox(width: AppSpacing.s8),
                          ],
                          Text(
                            widget.label,
                            style: textTheme.labelLarge?.copyWith(
                              color: _enabled
                                  ? AppColors.textPrimary
                                  : AppColors.textTertiary,
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
