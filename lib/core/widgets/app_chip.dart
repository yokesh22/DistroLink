import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Pill chip used for filters and quick-add shortcuts.
///
/// Pass [active] to highlight with primary-blue fill.
/// Pass [onTap] to make it tappable.
class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    super.key,
    this.active = false,
    this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = theme.colorScheme.outline;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm - 2,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.primary : border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: active
                ? Colors.white
                : theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
