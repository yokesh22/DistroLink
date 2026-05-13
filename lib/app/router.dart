import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:distro_link/features/admin/presentation/admin_order_summary_screen.dart';
import 'package:distro_link/features/admin/presentation/admin_shell.dart';
import 'package:distro_link/features/analytics/presentation/analytics_screen.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/auth/domain/app_user.dart';
import 'package:distro_link/features/auth/presentation/admin/add_edit_salesman_screen.dart';
import 'package:distro_link/features/auth/presentation/admin/salesmen_list_screen.dart';
import 'package:distro_link/features/auth/presentation/login_screen.dart';
import 'package:distro_link/features/catalog/domain/product.dart';
import 'package:distro_link/features/catalog/presentation/admin/add_edit_product_screen.dart';
import 'package:distro_link/features/catalog/presentation/admin/products_list_screen.dart';
import 'package:distro_link/features/dashboard/presentation/dashboard_screen.dart';
import 'package:distro_link/features/exports/application/export_controller.dart';
import 'package:distro_link/features/exports/presentation/export_screen.dart';
import 'package:distro_link/features/orders/presentation/new_order/add_items_screen.dart';
import 'package:distro_link/features/orders/presentation/new_order/bill_preview_screen.dart';
import 'package:distro_link/features/orders/presentation/new_order/order_details_screen.dart';
import 'package:distro_link/features/orders/presentation/new_order/select_shop_screen.dart';
import 'package:distro_link/features/orders/presentation/orders_list_screen.dart';
import 'package:distro_link/features/settings/presentation/settings_screen.dart';
import 'package:distro_link/features/shops/domain/area.dart';
import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:distro_link/features/shops/presentation/admin/add_edit_area_screen.dart';
import 'package:distro_link/features/shops/presentation/admin/add_edit_shop_screen.dart';
import 'package:distro_link/features/shops/presentation/admin/areas_list_screen.dart';
import 'package:distro_link/features/shops/presentation/admin/shops_list_screen.dart';
import 'package:distro_link/services/sync/sync_worker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final notifier = _RouterNotifier(ref);
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, _) => const LoginScreen(),
      ),

      // ── Salesman shell ───────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) =>
            _SalesmanShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, _) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/orders',
            builder: (_, _) => const OrdersListScreen(),
          ),
          GoRoute(
            path: '/analytics',
            builder: (_, _) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (_, _) => const SettingsScreen(),
          ),
        ],
      ),

      // ── New order flow (full-screen steps) ───────────────────────
      GoRoute(
        path: '/orders/new/1',
        builder: (_, _) => const SelectShopScreen(),
      ),
      GoRoute(
        path: '/orders/new/2',
        builder: (_, _) => const OrderDetailsScreen(),
      ),
      GoRoute(
        path: '/orders/new/3',
        builder: (_, _) => const AddItemsScreen(),
      ),
      GoRoute(
        path: '/orders/new/4',
        builder: (_, _) => const BillPreviewScreen(),
      ),

      // ── Salesman order detail (no bottom nav) ────────────────────
      GoRoute(
        path: '/orders/:id',
        builder: (_, state) => AdminOrderSummaryScreen(
          orderId: state.pathParameters['id']!,
        ),
      ),

      // ── Export (full-screen, no bottom nav) ──────────────────────
      GoRoute(
        path: '/settings/export',
        builder: (_, state) => ExportScreen(
          initialFormat:
              (state.extra as ExportFormat?) ?? ExportFormat.excel,
        ),
      ),

      // ── Admin shell ──────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) =>
            AdminShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: '/admin/dashboard',
            builder: (_, _) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/admin/salesmen',
            builder: (_, _) => const AdminSalesmenListScreen(),
          ),
          GoRoute(
            path: '/admin/shops',
            builder: (_, _) => const AdminShopsListScreen(),
          ),
          GoRoute(
            path: '/admin/products',
            builder: (_, _) => const AdminProductsListScreen(),
          ),
        ],
      ),

      // ── Admin push routes (no bottom nav) ────────────────────────
      GoRoute(
        path: '/admin/salesmen/add',
        builder: (_, _) => const AddEditSalesmanScreen(),
      ),
      GoRoute(
        path: '/admin/salesmen/:id/edit',
        builder: (_, state) =>
            AddEditSalesmanScreen(salesman: state.extra as Salesman?),
      ),
      GoRoute(
        path: '/admin/areas',
        builder: (_, _) => const AreasListScreen(),
      ),
      GoRoute(
        path: '/admin/areas/add',
        builder: (_, _) => const AddEditAreaScreen(),
      ),
      GoRoute(
        path: '/admin/areas/:id/edit',
        builder: (_, state) =>
            AddEditAreaScreen(area: state.extra as Area?),
      ),
      GoRoute(
        path: '/admin/shops/add',
        builder: (_, _) => const AddEditShopScreen(),
      ),
      GoRoute(
        path: '/admin/shops/:id/edit',
        builder: (_, state) =>
            AddEditShopScreen(shop: state.extra as Shop?),
      ),
      GoRoute(
        path: '/admin/products/add',
        builder: (_, _) => const AddEditProductScreen(),
      ),
      GoRoute(
        path: '/admin/products/:id/edit',
        builder: (_, state) =>
            AddEditProductScreen(product: state.extra as Product?),
      ),
      GoRoute(
        path: '/admin/orders/:id',
        builder: (_, state) => AdminOrderSummaryScreen(
          orderId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
}

// ─── Auth + role-aware redirect ───────────────────────────────────

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref
      ..listen(authStateStreamProvider, (_, _) => notifyListeners())
      ..listen(currentAppUserProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;
    final path = state.matchedLocation;

    if (!isLoggedIn) {
      return path == '/login' ? null : '/login';
    }

    final userAsync = _ref.read(currentAppUserProvider);
    final user = userAsync.asData?.value;

    // Still fetching — stay put to avoid premature redirect.
    if (userAsync.isLoading || (user == null && !userAsync.hasError)) {
      return null;
    }

    if (user == null) return path == '/login' ? null : '/login';

    final isAdmin = user.role == UserRole.admin ||
        user.role == UserRole.superAdmin;
    final isSalesman = user.role == UserRole.salesman;

    if (path == '/login') {
      return isAdmin ? '/admin/dashboard' : '/home';
    }

    if (isAdmin && _isSalesmanPath(path)) return '/admin/dashboard';
    if (isSalesman && _isAdminPath(path)) return '/home';

    return null;
  }

  bool _isSalesmanPath(String path) =>
      path.startsWith('/home') ||
      path.startsWith('/orders') ||
      path.startsWith('/analytics') ||
      path.startsWith('/settings');

  bool _isAdminPath(String path) => path.startsWith('/admin');
}

// ─── Salesman bottom nav shell ────────────────────────────────────

class _SalesmanShell extends ConsumerWidget {
  const _SalesmanShell({required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SyncWorkerState>(syncStatusProvider, (prev, next) {
      if (next.status != SyncStatus.done) return;

      final count = next.syncedCount;
      // Auto-sync with nothing to do → no toast (avoid noise on every startup).
      if (count == 0 && !next.isManual) {
        ref.read(syncStatusProvider.notifier).reset();
        return;
      }

      final msg = count > 0
          ? '$count order${count > 1 ? 's' : ''} synced to server'
          : 'Already up to date';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor:
              count > 0 ? AppColors.accent : null,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );

      // Reset so the snackbar doesn't re-trigger on next rebuild.
      ref.read(syncStatusProvider.notifier).state = const SyncWorkerState();
    });

    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.colorScheme.onSurface.withValues(alpha: 0.5);

    var currentIndex = 0;
    if (location.startsWith('/orders')) currentIndex = 1;
    if (location.startsWith('/analytics')) currentIndex = 2;
    if (location.startsWith('/settings')) currentIndex = 3;

    return Scaffold(
      body: child,
      floatingActionButton: currentIndex < 2
          ? FloatingActionButton(
              onPressed: () => context.go('/orders/new/1'),
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) {
          const paths = ['/home', '/orders', '/analytics', '/settings'];
          context.go(paths[i]);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded, color: secondary),
            selectedIcon: Icon(Icons.grid_view_rounded, color: primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined, color: secondary),
            selectedIcon:
                Icon(Icons.receipt_long_rounded, color: primary),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined, color: secondary),
            selectedIcon: Icon(Icons.bar_chart_rounded, color: primary),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: secondary),
            selectedIcon: Icon(Icons.settings_rounded, color: primary),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
