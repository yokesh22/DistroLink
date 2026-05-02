/// Design-system spacing + radius tokens.
///
/// 8px-based scale. Use these instead of magic numbers in widget code.
abstract final class AppSpacing {
  static const double xs = 8;
  static const double sm = 16;
  static const double md = 24;
  static const double lg = 32;

  /// Default screen-edge padding (16px).
  static const double screenPadding = sm;

  static const double radiusInput = 8;
  static const double radiusButton = 8;
  static const double radiusCard = 12;
}
