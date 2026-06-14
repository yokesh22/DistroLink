import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// +/− quantity stepper with large touch targets and a directly-editable
/// numeric field in the middle (type `100` instead of tapping `+` 100 times).
///
/// The `−` button is disabled when [value] is at [min]. Typed values are
/// clamped to [min]…[max] and normalised to [min] on blur if left empty/invalid.
/// Touch targets are 40×40dp per the design-system rule.
class AppQtyStepper extends StatefulWidget {
  const AppQtyStepper({
    required this.value,
    required this.onChanged,
    super.key,
    this.min = 1,
    this.max = 999,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  State<AppQtyStepper> createState() => _AppQtyStepperState();
}

class _AppQtyStepperState extends State<AppQtyStepper> {
  late final TextEditingController _ctrl;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: '${widget.value}');
    _focus.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(AppQtyStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reflect external value changes (e.g. +/- taps) unless the user is
    // actively typing — don't fight their input.
    if (!_focus.hasFocus && _ctrl.text != '${widget.value}') {
      _ctrl.text = '${widget.value}';
    }
  }

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocusChange)
      ..dispose();
    _ctrl.dispose();
    super.dispose();
  }

  /// Normalise the field when it loses focus: empty/invalid/too-low → min.
  void _onFocusChange() {
    if (_focus.hasFocus) return;
    final parsed = int.tryParse(_ctrl.text);
    final clamped = (parsed ?? widget.min).clamp(widget.min, widget.max);
    _ctrl.text = '$clamped';
    if (clamped != widget.value) widget.onChanged(clamped);
  }

  /// Emit a value from the +/- buttons and keep the field in sync.
  void _step(int next) {
    final clamped = next.clamp(widget.min, widget.max);
    _ctrl.text = '$clamped';
    widget.onChanged(clamped);
  }

  void _onTextChanged(String text) {
    final parsed = int.tryParse(text);
    if (parsed == null) return; // empty mid-edit — wait for blur to normalise.
    if (parsed > widget.max) {
      final maxText = '${widget.max}';
      _ctrl
        ..text = maxText
        ..selection = TextSelection.collapsed(offset: maxText.length);
      widget.onChanged(widget.max);
      return;
    }
    // Allow below-min mid-typing (e.g. a transient "0"); blur normalises it.
    if (parsed >= widget.min) widget.onChanged(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = theme.colorScheme.outline;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: border, width: 1.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
        color: theme.colorScheme.surface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            onTap: widget.value > widget.min
                ? () => _step(widget.value - 1)
                : null,
          ),
          Container(width: 1, height: 40, color: border),
          SizedBox(
            width: 48,
            height: 40,
            child: Center(
              child: TextField(
                controller: _ctrl,
                focusNode: _focus,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter('${widget.max}'.length),
                ],
                textAlign: TextAlign.center,
                onChanged: _onTextChanged,
                onTapOutside: (_) => _focus.unfocus(),
                onSubmitted: (_) => _focus.unfocus(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                ),
              ),
            ),
          ),
          Container(width: 1, height: 40, color: border),
          _StepButton(
            icon: Icons.add,
            onTap: widget.value < widget.max
                ? () => _step(widget.value + 1)
                : null,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(
          icon,
          size: 20,
          color: onTap != null
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
