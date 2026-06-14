import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/auth/application/signup_request_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shown to a signed-in distributor whose signup request is still pending
/// super-admin review. They have no app access until approved.
class PendingApprovalScreen extends ConsumerStatefulWidget {
  const PendingApprovalScreen({super.key});

  @override
  ConsumerState<PendingApprovalScreen> createState() =>
      _PendingApprovalScreenState();
}

class _PendingApprovalScreenState
    extends ConsumerState<PendingApprovalScreen> {
  bool _checking = false;

  Future<void> _checkStatus() async {
    setState(() => _checking = true);
    // Re-fetch both the request status and the provisioning state; the router
    // redirects automatically once a `users` row exists (approved).
    ref
      ..invalidate(mySignupRequestProvider)
      ..invalidate(currentAppUserProvider);
    await ref.read(mySignupRequestProvider.future);
    if (mounted) setState(() => _checking = false);
  }

  Future<void> _logout() => ref.read(authRepositoryProvider).signOut();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.hourglass_top_rounded,
                    size: 40,
                    color: AppColors.warning,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Account under review',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Thanks for signing up! Your account is waiting for approval. '
                "We'll activate it shortly — check back in a little while.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              AppButton(
                label: 'Check status',
                loading: _checking,
                onPressed: _checkStatus,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: _logout,
                child: const Text('Log out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
