import 'package:distro_link/app/router.dart';
import 'package:distro_link/app/theme.dart';
import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/auth/domain/app_user.dart';
import 'package:distro_link/features/settings/application/settings_providers.dart';
import 'package:distro_link/services/sync/sync_worker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DistroLinkApp extends ConsumerWidget {
  const DistroLinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Eagerly start the sync worker.
    // keepAlive: true — persists for the app lifetime.
    ref.read<void>(syncWorkerProvider);

    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    final isSalesman =
        ref.watch(currentAppUserProvider).value?.role == UserRole.salesman;
    final primary =
        isSalesman ? AppColors.salesmanPrimary : AppColors.primary;

    return MaterialApp.router(
      title: 'DistroLink',
      theme: AppTheme.light(primary: primary),
      darkTheme: AppTheme.dark(primary: primary),
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
