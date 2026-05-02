import 'package:flutter/material.dart';

/// Button variants — see docs/design-system.md.
enum AppButtonVariant { primary, secondary }

/// Themed button with full-width and loading affordances.
///
/// Defaults to full width because the design system says important actions
/// should be full width — opt out with `fullWidth: false` when inline.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
    this.fullWidth = true,
    this.loading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool fullWidth;
  final bool loading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || loading;
    final child = loading
        ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        : _buttonChild();

    final button = switch (variant) {
      AppButtonVariant.primary => ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        child: child,
      ),
    };

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }

  Widget _buttonChild() {
    if (icon == null) return Text(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
