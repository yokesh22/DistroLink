import 'package:flutter/material.dart';

/// Design-system color tokens for DistroLink.
///
/// Source of truth: docs/design-system.md.
/// Do not introduce new colors without updating that document first.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF2563EB); // blue
  // Orange — salesman flow brand color
  static const Color salesmanPrimary = Color(0xFFF28C28);
  static const Color accent = Color(0xFF10B981); // green — totals/success only

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Light neutrals
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF8FAFC);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Dark neutrals
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Tints — light (used for badge backgrounds, card fills, etc.)
  static const Color blueLight = Color(0xFFEFF6FF);
  static const Color blueMid = Color(0xFFBFDBFE);
  static const Color greenLight = Color(0xFFECFDF5);
  static const Color orangeLight = Color(0xFFFFFBEB);
  static const Color redLight = Color(0xFFFEF2F2);

  // Tints — dark
  static const Color darkBlueLight = Color(0xFF1E3A5F);
  static const Color darkBlueMid = Color(0xFF1E3A5F);
  static const Color darkGreenLight = Color(0xFF064E3B);
  static const Color darkOrangeLight = Color(0xFF431407);
  static const Color darkRedLight = Color(0xFF450A0A);
}
