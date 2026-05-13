import 'dart:async';

import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    unawaited(_controller.forward());

    unawaited(
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (!mounted) return;
        context.go('/login');
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _SplashBackground(
        isDark: isDark,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: SizedBox.expand(
                child: Column(
                  children: [
                    const Spacer(flex: 3),
                    _AppIcon(isDark: isDark),
                    const SizedBox(height: AppSpacing.lg),
                    _BrandText(isDark: isDark),
                    const SizedBox(height: AppSpacing.xs),
                    _Tagline(isDark: isDark),
                    const Spacer(flex: 3),
                    _ThreeDots(isDark: isDark),
                    const SizedBox(height: AppSpacing.sm),
                    _VersionLabel(isDark: isDark),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Background gradient ────────────────────────────────────────────

class _SplashBackground extends StatelessWidget {
  const _SplashBackground({required this.isDark, required this.child});

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (isDark) {
      return ColoredBox(
        color: AppColors.darkBackground,
        child: child,
      );
    }
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFDCEDFF), // light blue tint
            Color(0xFFEFF6FF),
            Color(0xFFF8FBFF),
            Color(0xFFFFFFFF),
          ],
          stops: [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: child,
    );
  }
}

// ── App icon ───────────────────────────────────────────────────────

class _AppIcon extends StatelessWidget {
  const _AppIcon({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Image.asset(
        isDark
            ? 'assets/icons/icon_dark_1024.png'
            : 'assets/icons/icon_light_1024.png',
        fit: BoxFit.contain,
      ),
    );
  }
}

// ── Brand name ─────────────────────────────────────────────────────

class _BrandText extends StatelessWidget {
  const _BrandText({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    const style = TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
      height: 1,
    );
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(text: 'Distro', style: style.copyWith(color: textColor)),
          TextSpan(
            text: 'Link',
            style: style.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

// ── Tagline ────────────────────────────────────────────────────────

class _Tagline extends StatelessWidget {
  const _Tagline({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Smarter distribution, every order.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        letterSpacing: 0.1,
      ),
    );
  }
}

// ── Three dots ─────────────────────────────────────────────────────

class _ThreeDots extends StatelessWidget {
  const _ThreeDots({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final isMiddle = i == 1;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isMiddle ? 8 : 6,
          height: isMiddle ? 8 : 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: isMiddle ? 0.7 : 0.35),
          ),
        );
      }),
    );
  }
}

// ── Version label ──────────────────────────────────────────────────

class _VersionLabel extends StatelessWidget {
  const _VersionLabel({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      'V1.0 · MADE FOR DISTRIBUTORS',
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
        color: (isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary)
            .withValues(alpha: 0.6),
      ),
    );
  }
}
