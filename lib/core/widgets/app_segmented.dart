import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Pill-style segmented control.
///
/// Maps a list of [options] to a horizontal row of tappable segments.
/// The segment at [selectedIndex] is highlighted in primary blue; others
/// are ghost-style on the surface color.
class AppSegmented extends StatelessWidget {
  const AppSegmented({
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    super.key,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = theme.colorScheme.outline;
    final surface = theme.colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: i == selectedIndex
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusButton - 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    options[i],
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: i == selectedIndex
                          ? Colors.white
                          : theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
