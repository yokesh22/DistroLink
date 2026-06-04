import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_providers.g.dart';

/// Tracks whether the admin has explicitly dismissed the onboarding wizard
/// (by tapping "Go to Dashboard"). Kept alive so it persists across the
/// dashboard rebuild — prevents the redirect loop when 0 salesmen exist.
@Riverpod(keepAlive: true)
class OnboardingDismissed extends _$OnboardingDismissed {
  @override
  bool build() => false;

  void dismiss() => state = true;
}
