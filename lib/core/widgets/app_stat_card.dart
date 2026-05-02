import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:flutter/material.dart';

/// Summary stat tile — label + large value + optional footnote.
///
/// Used on the Dashboard and Analytics screens. Wraps [AppCard] with the
/// design-system stat layout.
class AppStatCard extends StatelessWidget {
  const AppStatCard({
    required this.label,
    required this.value,
    super.key,
    this.footnote,
    this.footnoteColor,
    this.backgroundColor,
    this.valueColor,
    this.child,
  });

  final String label;
  final String value;
  final String? footnote;
  final Color? footnoteColor;
  final Color? backgroundColor;
  final Color? valueColor;

  /// Optional widget rendered below the value (e.g. a progress bar).
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = theme.colorScheme.onSurface.withValues(alpha: 0.5);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm - 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: secondary,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: valueColor ?? theme.colorScheme.onSurface,
            ),
          ),
          if (footnote != null) ...[
            const SizedBox(height: 2),
            Text(
              footnote!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: footnoteColor ?? secondary,
              ),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: AppSpacing.xs / 2),
            child!,
          ],
        ],
      ),
    );
  }
}
