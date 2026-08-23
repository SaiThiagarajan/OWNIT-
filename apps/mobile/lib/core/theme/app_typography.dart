import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Space Grotesk drives headings, buttons, and numerals; Inter drives body
/// copy and labels, per the OWNIT spec. [textTheme] wires that split into
/// Material's [TextTheme] roles so widgets can keep using
/// `Theme.of(context).textTheme.*` without knowing which typeface backs it.
class AppTypography {
  const AppTypography._();

  static TextTheme get textTheme {
    final inter = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);
    return inter
        .copyWith(
          displayLarge: GoogleFonts.spaceGrotesk(textStyle: inter.displayLarge),
          displayMedium: GoogleFonts.spaceGrotesk(textStyle: inter.displayMedium),
          displaySmall: GoogleFonts.spaceGrotesk(textStyle: inter.displaySmall),
          headlineLarge: GoogleFonts.spaceGrotesk(textStyle: inter.headlineLarge),
          headlineMedium: GoogleFonts.spaceGrotesk(textStyle: inter.headlineMedium),
          headlineSmall: GoogleFonts.spaceGrotesk(textStyle: inter.headlineSmall),
          titleLarge: GoogleFonts.spaceGrotesk(
            textStyle: inter.titleLarge,
            fontWeight: FontWeight.w600,
          ),
          labelLarge: GoogleFonts.spaceGrotesk(
            textStyle: inter.labelLarge,
            fontWeight: FontWeight.w600,
          ),
        )
        .apply(bodyColor: AppColors.textPrimary, displayColor: AppColors.textPrimary);
  }

  /// Space Grotesk with tabular figures, for standalone numerals such as
  /// OTP digits or match-confidence percentages that aren't part of a
  /// standard heading/body role.
  static TextStyle numeral({
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}
