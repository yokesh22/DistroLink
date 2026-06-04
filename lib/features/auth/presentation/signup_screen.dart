import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_text_field.dart';
import 'package:distro_link/features/auth/application/distributor_signup_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _businessNameCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _businessNameCtrl.dispose();
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  String? _validate() {
    if (_businessNameCtrl.text.trim().isEmpty) {
      return 'Enter your business name.';
    }
    if (_fullNameCtrl.text.trim().isEmpty) return 'Enter your full name.';
    if (_phoneCtrl.text.trim().isEmpty) return 'Enter your phone number.';
    if (_emailCtrl.text.trim().isEmpty) return 'Enter your email address.';
    if (_passCtrl.text.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    if (_passCtrl.text != _confirmPassCtrl.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  Future<void> _submit() async {
    final validationError = _validate();
    if (validationError != null) {
      setState(() => _error = validationError);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(distributorSignupRepositoryProvider).signup(
            email: _emailCtrl.text.trim(),
            password: _passCtrl.text,
            businessName: _businessNameCtrl.text.trim(),
            fullName: _fullNameCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
          );
      if (mounted) {
        context.go(
          '/verify-email?email=${Uri.encodeComponent(_emailCtrl.text.trim())}',
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        final msg = e.toString().replaceFirst('Exception: ', '');
        setState(() => _error = msg.isNotEmpty
            ? msg
            : 'Sign-up failed. Please check your connection and try again.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/login')),
        title: const Text('Create Account'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding + 8,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Set up your distributor account',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Fill in your details to get started. '
                "You'll verify your email before signing in.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _businessNameCtrl,
                label: 'Business Name',
                hint: 'e.g. Sharma Distributors',
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.sm),

              AppTextField(
                controller: _fullNameCtrl,
                label: 'Your Full Name',
                hint: 'e.g. Rahul Sharma',
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.sm),

              AppTextField(
                controller: _phoneCtrl,
                label: 'Phone Number',
                hint: '9876543210',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.sm),

              AppTextField(
                controller: _emailCtrl,
                label: 'Email',
                hint: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.sm),

              AppTextField(
                controller: _passCtrl,
                label: 'Password',
                hint: 'Min. 8 characters',
                obscureText: _obscurePass,
                textInputAction: TextInputAction.next,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePass
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePass = !_obscurePass),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              AppTextField(
                controller: _confirmPassCtrl,
                label: 'Confirm Password',
                hint: 'Re-enter your password',
                obscureText: _obscureConfirm,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              if (_error != null) ...[
                Text(
                  _error!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.error),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],

              AppButton(
                label: 'Create Account',
                loading: _loading,
                onPressed: _submit,
              ),

              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: theme.textTheme.bodySmall,
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
