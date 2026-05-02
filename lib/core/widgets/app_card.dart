import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Themed card wrapper that applies design-system padding by default.
///
/// Use this instead of raw [Card] so padding stays consistent across screens.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.sm),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      child: Padding(padding: padding, child: child),
    );
    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: card,
    );
  }
}
