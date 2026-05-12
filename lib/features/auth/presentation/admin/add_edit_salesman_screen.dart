import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_text_field.dart';
import 'package:distro_link/features/auth/application/admin_salesman_providers.dart';
import 'package:distro_link/features/auth/domain/app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddEditSalesmanScreen extends ConsumerStatefulWidget {
  const AddEditSalesmanScreen({super.key, this.salesman});
  final Salesman? salesman;

  @override
  ConsumerState<AddEditSalesmanScreen> createState() =>
      _AddEditSalesmanScreenState();
}

class _AddEditSalesmanScreenState
    extends ConsumerState<AddEditSalesmanScreen> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _newPassword;
  bool _obscurePassword = true;
  bool _obscureNewPassword = true;
  bool _loading = false;
  String? _error;

  bool get _isEdit => widget.salesman != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.salesman?.name ?? '');
    _phone = TextEditingController(text: widget.salesman?.phone ?? '');
    _email = TextEditingController(text: widget.salesman?.email ?? '');
    _password = TextEditingController();
    _newPassword = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    _newPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    final phone = _phone.text.trim();
    final email = _email.text.trim();
    final password = _password.text;

    if (name.isEmpty || phone.isEmpty || email.isEmpty) {
      setState(() => _error = 'Name, phone and email are required.');
      return;
    }
    if (!_isEdit && password.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters.');
      return;
    }
    final newPwd = _newPassword.text;
    if (_isEdit && newPwd.isNotEmpty && newPwd.length < 6) {
      setState(() => _error = 'New password must be at least 6 characters.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final notifier = ref.read(adminSalesmenListProvider.notifier);
      if (_isEdit) {
        final s = widget.salesman!;
        await notifier.updateSalesman(
          id: s.id,
          userId: s.userId ?? '',
          fullName: name,
          phone: phone,
          email: email,
        );
        if (newPwd.isNotEmpty) {
          await notifier.resetPassword(
            userId: s.userId ?? '',
            newPassword: newPwd,
          );
        }
      } else {
        await notifier.create(
          fullName: name,
          phone: phone,
          email: email,
          password: password,
        );
      }
      if (mounted) context.pop();
    } on Exception catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleActive() async {
    final s = widget.salesman!;
    setState(() => _loading = true);
    try {
      await ref.read(adminSalesmenListProvider.notifier).toggleActive(
            salesmanId: s.id,
            userId: s.userId ?? '',
            isActive: !s.isActive,
          );
      if (mounted) context.pop();
    } on Exception catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = widget.salesman?.isActive ?? true;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.screenPadding,
                AppSpacing.screenPadding,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isEdit ? 'Edit Salesman' : 'Add Salesman',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isEdit) ...[
                      _SalesmanProfileCard(salesman: widget.salesman!),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    AppTextField(
                      controller: _name,
                      label: 'Full Name',
                      hint: 'e.g. Ravi Kumar',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(
                      controller: _phone,
                      label: 'Phone',
                      hint: '9876543210',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(
                      controller: _email,
                      label: 'Email',
                      hint: 'ravi@example.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction:
                          _isEdit ? TextInputAction.next : TextInputAction.next,
                      enabled: !_isEdit,
                    ),
                    if (_isEdit) ...[
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        controller: _newPassword,
                        label: 'New Password',
                        hint: 'Leave blank to keep current password',
                        obscureText: _obscureNewPassword,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _obscureNewPassword = !_obscureNewPassword,
                          ),
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusCard,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lightbulb_outline_rounded,
                              size: 14,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Salesman logs in with email and password.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.warning,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (!_isEdit) ...[
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        controller: _password,
                        label: 'Temporary Password',
                        hint: 'Min 6 characters',
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        _error!,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: _isEdit ? 'Save Changes' : 'Add Salesman',
                      loading: _loading,
                      onPressed: _loading ? null : _submit,
                    ),
                    if (_isEdit) ...[
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        label: isActive
                            ? 'Deactivate Salesman'
                            : 'Reactivate Salesman',
                        variant: AppButtonVariant.secondary,
                        loading: _loading,
                        onPressed: _loading ? null : _toggleActive,
                        icon: isActive
                            ? Icons.block_rounded
                            : Icons.check_circle_outline_rounded,
                      ),
                      if (!isActive)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            'Deactivated salesmen cannot log in.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesmanProfileCard extends StatelessWidget {
  const _SalesmanProfileCard({required this.salesman});
  final Salesman salesman;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = salesman.name.isNotEmpty
        ? salesman.name[0].toUpperCase()
        : '?';
    final since = DateFormat('MMM yyyy').format(salesman.createdAt);
    final statusLabel = salesman.isActive ? 'Active' : 'Inactive';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
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
                  salesman.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$statusLabel since $since',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
