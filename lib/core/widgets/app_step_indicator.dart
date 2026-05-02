import 'package:distro_link/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// 4-step horizontal progress indicator for the order creation flow.
///
/// Steps before [currentStep] show a green check; [currentStep] is blue;
/// steps after are grey. [total] defaults to 4.
class AppStepIndicator extends StatelessWidget {
  const AppStepIndicator({
    required this.currentStep,
    super.key,
    this.total = 4,
  });

  final int currentStep;
  final int total;

  @override
  Widget build(BuildContext context) {
    final border = Theme.of(context).colorScheme.outline;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          for (var i = 1; i <= total; i++) ...[
            _StepDot(step: i, currentStep: currentStep, border: border),
            if (i < total)
              Expanded(
                child: Container(
                  height: 2,
                  color: i < currentStep ? AppColors.accent : border,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.step,
    required this.currentStep,
    required this.border,
  });

  final int step;
  final int currentStep;
  final Color border;

  @override
  Widget build(BuildContext context) {
    final isDone = step < currentStep;
    final isActive = step == currentStep;

    Color bg;
    Color fg;
    if (isDone) {
      bg = AppColors.accent;
      fg = Colors.white;
    } else if (isActive) {
      bg = AppColors.primary;
      fg = Colors.white;
    } else {
      bg = Theme.of(context).colorScheme.surface;
      fg = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        border: Border.all(color: isDone || isActive ? bg : border, width: 2),
      ),
      alignment: Alignment.center,
      child: isDone
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : Text(
              '$step',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
    );
  }
}
