import 'package:distro_link/features/analytics/presentation/analytics_screen.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/auth/presentation/login_screen.dart';
import 'package:distro_link/features/dashboard/presentation/dashboard_screen.dart';
import 'package:distro_link/features/orders/presentation/new_order/add_items_screen.dart';
import 'package:distro_link/features/orders/presentation/new_order/bill_preview_screen.dart';
import 'package:distro_link/features/orders/presentation/new_order/order_details_screen.dart';
import 'package:distro_link/features/orders/presentation/new_order/select_shop_screen.dart';
import 'package:distro_link/features/orders/presentation/orders_list_screen.dart';
import 'package:distro_link/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
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
      GoRoute(
        path: '/admin-not-yet',
        builder: (_, _) => const _AdminPlaceholder(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            _AppShell(location: state.matchedLocation, child: child),
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
    ],
  );
}

// ─── Auth-aware redirect ──────────────────────────────────────────

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen(authStateStreamProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;
    final path = state.matchedLocation;

    if (!isLoggedIn) {
      return path == '/login' ? null : '/login';
    }
    if (path == '/login') return '/home';
    return null;
  }
}

// ─── Bottom nav shell ─────────────────────────────────────────────

class _AppShell extends StatelessWidget {
  const _AppShell({required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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

// ─── Admin placeholder ────────────────────────────────────────────

class _AdminPlaceholder extends StatelessWidget {
  const _AdminPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DistroLink')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction_rounded,
                  size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Admin module coming soon',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Phase 2 will unlock the admin dashboard, '
                'salesmen, shops and products.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
