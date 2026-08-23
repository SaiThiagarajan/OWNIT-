import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Shows a modal bottom sheet with the design system's 28px top radius, a
/// drag handle, and safe-area-aware padding.
class AppBottomSheet {
  const AppBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    String? title,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusBottomSheet)),
      ),
      builder: (context) {
        // isScrollControlled hands us the full-height sheet route, so we
        // size to content ourselves and pad for the keyboard (viewInsets)
        // on top of the safe-area inset (padding) — without this a sheet
        // with a text field would be covered by the keyboard instead of
        // resizing above it.
        final viewInsets = MediaQuery.of(context).viewInsets.bottom;
        final bottomPadding = MediaQuery.of(context).padding.bottom;
        final textTheme = Theme.of(context).textTheme;
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.screenHorizontal,
            right: AppSpacing.screenHorizontal,
            top: AppSpacing.s12,
            bottom: viewInsets + (viewInsets > 0 ? AppSpacing.s16 : bottomPadding + AppSpacing.s16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(AppSpacing.s4),
                    ),
                  ),
                ),
                if (title != null) ...[
                  const SizedBox(height: AppSpacing.s16),
                  Text(title, style: textTheme.titleLarge),
                ],
                const SizedBox(height: AppSpacing.s16),
                builder(context),
              ],
            ),
          ),
        );
      },
    );
  }
}
