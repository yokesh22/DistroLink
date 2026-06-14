import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/auth/application/signup_request_providers.dart';
import 'package:distro_link/features/auth/domain/signup_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tab order on the super-admin approvals screen.
const List<SignupRequestStatus> _tabStatuses = [
  SignupRequestStatus.pending,
  SignupRequestStatus.approved,
  SignupRequestStatus.rejected,
];

/// The brand colour that represents each request state.
Color _statusColor(SignupRequestStatus status) => switch (status) {
      SignupRequestStatus.pending => AppColors.warning,
      SignupRequestStatus.approved => AppColors.accent,
      SignupRequestStatus.rejected => AppColors.error,
    };

String _statusLabel(SignupRequestStatus status) => switch (status) {
      SignupRequestStatus.pending => 'Pending',
      SignupRequestStatus.approved => 'Approved',
      SignupRequestStatus.rejected => 'Declined',
    };

/// Super-admin queue of distributor signup requests, split into Pending /
/// Approved / Declined tabs. Accounts can be moved between states freely
/// (approve a declined account, revoke an approved one).
class SuperAdminApprovalsScreen extends ConsumerStatefulWidget {
  const SuperAdminApprovalsScreen({super.key});

  @override
  ConsumerState<SuperAdminApprovalsScreen> createState() =>
      _SuperAdminApprovalsScreenState();
}

class _SuperAdminApprovalsScreenState
    extends ConsumerState<SuperAdminApprovalsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: _tabStatuses.length, vsync: this)
      // Rebuild on tab change so the indicator picks up the active colour.
      ..addListener(() {
        if (!_controller.indexIsChanging) setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = _statusColor(_tabStatuses[_controller.index]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Distributor Accounts'),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: activeColor,
          indicatorWeight: 3,
          labelColor: activeColor,
          unselectedLabelColor:
              theme.colorScheme.onSurface.withValues(alpha: 0.5),
          labelStyle: theme.textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.w700),
          tabs: [
            for (final status in _tabStatuses)
              Tab(text: _statusLabel(status)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          for (final status in _tabStatuses) _RequestList(status: status),
        ],
      ),
    );
  }
}

class _RequestList extends ConsumerWidget {
  const _RequestList({required this.status});

  final SignupRequestStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(signupRequestsByStatusProvider(status));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(signupRequestsByStatusProvider(status));
        await ref.read(signupRequestsByStatusProvider(status).future);
      },
      child: requests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
          error: e,
          onRetry: () =>
              ref.invalidate(signupRequestsByStatusProvider(status)),
        ),
        data: (list) {
          if (list.isEmpty) return _EmptyView(status: status);
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, i) => _RequestCard(request: list[i]),
          );
        },
      ),
    );
  }
}

class _RequestCard extends ConsumerStatefulWidget {
  const _RequestCard({required this.request});

  final SignupRequest request;

  @override
  ConsumerState<_RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends ConsumerState<_RequestCard> {
  bool _busy = false;

  /// Refresh every tab — an action moves the request between lists.
  void _invalidateAll() {
    for (final status in _tabStatuses) {
      ref.invalidate(signupRequestsByStatusProvider(status));
    }
  }

  Future<void> _run(Future<void> Function() action, String successMsg) async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await action();
      _invalidateAll();
      messenger.showSnackBar(
        SnackBar(
          content: Text(successMsg),
          backgroundColor: AppColors.accent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on Exception catch (e) {
      if (mounted) setState(() => _busy = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _approve() {
    final repo = ref.read(signupRequestsRepositoryProvider);
    return _run(
      () => repo.approve(widget.request.id),
      '${widget.request.businessName} approved',
    );
  }

  Future<void> _decline() async {
    final reason = await _promptReason();
    if (reason == null) return; // cancelled
    final repo = ref.read(signupRequestsRepositoryProvider);
    await _run(
      () => repo.reject(widget.request.id, reason: reason),
      '${widget.request.businessName} declined',
    );
  }

  Future<String?> _promptReason() {
    final ctrl = TextEditingController();
    final isRevoke = widget.request.status == SignupRequestStatus.approved;
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isRevoke ? 'Revoke access' : 'Decline request'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Reason (optional, shown to the applicant)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(isRevoke ? 'Revoke' : 'Decline'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = widget.request;
    final showApprove = r.status != SignupRequestStatus.approved;
    final showDecline = r.status != SignupRequestStatus.rejected;
    final blockedOnEmail = showApprove && !r.emailVerified;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  r.businessName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _VerifiedBadge(verified: r.emailVerified),
            ],
          ),
          const SizedBox(height: 4),
          _InfoRow(icon: Icons.person_outline, text: r.fullName),
          _InfoRow(icon: Icons.email_outlined, text: r.email),
          _InfoRow(icon: Icons.phone_outlined, text: r.phone),
          if (r.status == SignupRequestStatus.rejected &&
              (r.rejectionReason?.isNotEmpty ?? false)) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Reason: ${r.rejectionReason}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          if (_busy)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            Row(
              children: [
                if (showDecline)
                  Expanded(
                    child: AppButton(
                      label: r.status == SignupRequestStatus.approved
                          ? 'Revoke'
                          : 'Decline',
                      variant: AppButtonVariant.secondary,
                      onPressed: _decline,
                    ),
                  ),
                if (showDecline && showApprove)
                  const SizedBox(width: AppSpacing.sm),
                if (showApprove)
                  Expanded(
                    child: AppButton(
                      label: 'Approve',
                      onPressed: r.emailVerified ? _approve : null,
                    ),
                  ),
              ],
            ),
          if (blockedOnEmail) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              "Waiting for the applicant to verify their email — can't "
              'approve yet.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.warning,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({required this.verified});

  final bool verified;

  @override
  Widget build(BuildContext context) {
    final color = verified ? AppColors.accent : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        verified ? 'Email verified' : 'Unverified',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.status});

  final SignupRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = _statusLabel(status).toLowerCase();
    return ListView(
      children: [
        const SizedBox(height: 120),
        Icon(
          Icons.inbox_outlined,
          size: 56,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'No $label accounts',
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Could not load requests',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Retry',
              fullWidth: false,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
