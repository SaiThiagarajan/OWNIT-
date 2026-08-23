import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// A labeled text field. The label is always rendered above the field (not
/// just a hint or a floating label) so every input has an explicit,
/// always-visible form label for accessibility. Errors are shown with both
/// an icon and text, so they never rely on color alone.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.prefixIcon,
    this.inputFormatters,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s8),
        SizedBox(
          height: AppSpacing.controlHeight,
          child: Semantics(
            textField: true,
            label: label,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              obscureText: obscureText,
              enabled: enabled,
              inputFormatters: inputFormatters,
              onChanged: onChanged,
              style: textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: prefixIcon,
                errorText: null,
              ).copyWith(
                enabledBorder: hasError
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                        borderSide: const BorderSide(color: AppColors.error),
                      )
                    : null,
                focusedBorder: hasError
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
                      )
                    : null,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.s8),
          Semantics(
            liveRegion: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.error_outline, size: 16, color: AppColors.error),
                const SizedBox(width: AppSpacing.s4),
                Expanded(
                  child: Text(
                    errorText!,
                    style: textTheme.bodySmall?.copyWith(color: AppColors.error),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
