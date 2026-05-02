import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Inter-based typography scale matching the design system.
///
/// Build a [TextTheme] for either brightness via [build]; the resulting theme
/// is wired into [ThemeData] in lib/app/theme.dart.
abstract final class AppTypography {
  /// Returns a [TextTheme] using Inter on top of the given color.
  static TextTheme build({required Color textColor}) {
    final base = ThemeData(
      brightness: textColor.computeLuminance() > 0.5
          ? Brightness.dark
          : Brightness.light,
    ).textTheme;

    return GoogleFonts.interTextTheme(base).copyWith(
      // Heading: 20–24px semi-bold
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      // Subheading: 16–18px medium
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.4,
      ),
      // Body: 14–16px regular
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
      ),
      // Small: 12–13px
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.2,
      ),
    );
  }

  /// Slightly emphasised numeric style (price, qty, totals) — see design system.
  static TextStyle numeric({required Color color, double size = 16}) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}
