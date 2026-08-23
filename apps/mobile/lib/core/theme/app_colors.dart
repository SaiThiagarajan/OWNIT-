import 'package:flutter/material.dart';

/// The OWNIT color palette, as defined by the approved UI/UX specification
/// in `docs/OWNIT_SPEC.md`. Do not introduce new colors outside this file —
/// every surface, text, and accent color in the app should resolve here.
class AppColors {
  const AppColors._();

  static const Color background = Color(0xFF0B0A09);
  static const Color surface = Color(0xFF151310);
  static const Color surfaceElevated = Color(0xFF1A1815);
  static const Color border = Color(0xFF2F2C27);

  static const Color textPrimary = Color(0xFFF5F2EC);
  static const Color textSecondary = Color(0xFFA39C8F);
  static const Color textTertiary = Color(0xFF6F685C);

  static const Color orange = Color(0xFFFF7A1A);

  static const Color lostCoral = Color(0xFFFF8A66);
  static const Color lostTint = Color(0xFF2B1A15);

  static const Color foundTeal = Color(0xFF4FD6C4);
  static const Color foundTint = Color(0xFF123330);

  static const Color error = Color(0xFFFF6B5C);

  /// Text drawn on top of [orange] or [foundTeal] fills (e.g. the report
  /// FAB, filled indicators) needs a dark foreground to stay accessible —
  /// the palette above only defines light-on-dark text colors.
  static const Color onAccent = background;
}
