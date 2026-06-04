import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/onboarding/application/onboarding_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_screen.g.dart';

@riverpod
Future<String> distributorName(Ref ref) async {
  final user = await ref.watch(currentAppUserProvider.future);
  if (user == null) return 'DistroLink';
  final client = ref.watch(supabaseClientProvider);
  final row = await client
      .from('distributors')
      .select('name')
      .eq('id', user.distributorId)
      .single();
  return (row['name'] as String?) ?? 'DistroLink';
}

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final nameAsync = ref.watch(distributorNameProvider);
    final bizName = nameAsync.asData?.value ?? '';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding + 8,
            vertical: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Brand mark
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.rocket_launch_rounded,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              Text(
                bizName.isNotEmpty
                    ? 'Welcome to DistroLink,\n$bizName!'
                    : 'Welcome to DistroLink!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "Your account is ready. Let's set up your team "
                'and start taking orders.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Setup checklist
              const _StepTile(
                number: '1',
                title: 'Add your salesmen',
                subtitle: 'Create login accounts for your field team.',
              ),
              const SizedBox(height: AppSpacing.xs),
              const _StepTile(
                number: '2',
                title: 'Add areas & shops',
                subtitle: 'Set up the areas and shops your team will visit.',
              ),
              const SizedBox(height: AppSpacing.xs),
              const _StepTile(
                number: '3',
                title: 'Add your product catalog',
                subtitle: 'Enter products, prices, and GST slabs.',
              ),

              const Spacer(),

              AppButton(
                label: 'Add Your First Salesman',
                onPressed: () => context.go('/admin/salesmen/add'),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton(
                onPressed: () {
                  ref
                      .read(onboardingDismissedProvider.notifier)
                      .dismiss();
                  context.go('/admin/dashboard');
                },
                child: Text(
                  'Go to Dashboard',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  final String number;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
