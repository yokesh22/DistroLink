import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:distro_link/features/admin/presentation/admin_order_summary_screen.dart';
import 'package:distro_link/features/admin/presentation/admin_shell.dart';
import 'package:distro_link/features/analytics/presentation/analytics_screen.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/auth/application/signup_request_providers.dart';
import 'package:distro_link/features/auth/domain/app_user.dart';
import 'package:distro_link/features/auth/domain/signup_request.dart';
import 'package:distro_link/features/auth/presentation/account_declined_screen.dart';
import 'package:distro_link/features/auth/presentation/admin/add_edit_salesman_screen.dart';
import 'package:distro_link/features/auth/presentation/admin/salesmen_list_screen.dart';
import 'package:distro_link/features/auth/presentation/login_screen.dart';
import 'package:distro_link/features/auth/presentation/pending_approval_screen.dart';
import 'package:distro_link/features/auth/presentation/signup_screen.dart';
import 'package:distro_link/features/auth/presentation/super_admin/approvals_screen.dart';
import 'package:distro_link/features/auth/presentation/verify_email_screen.dart';
import 'package:distro_link/features/catalog/domain/product.dart';
import 'package:distro_link/features/catalog/presentation/admin/add_edit_product_screen.dart';
import 'package:distro_link/features/catalog/presentation/admin/products_list_screen.dart';
import 'package:distro_link/features/dashboard/presentation/dashboard_screen.dart';
import 'package:distro_link/features/exports/application/export_controller.dart';
import 'package:distro_link/features/exports/presentation/export_screen.dart';
import 'package:distro_link/features/onboarding/presentation/onboarding_screen.dart';
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
import 'package:distro_link/features/splash/presentation/splash_screen.dart';
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
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (_, _) => const SignupScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (_, state) => VerifyEmailScreen(
          email: state.uri.queryParameters['email'] ?? '',
        ),
      ),
      GoRoute(
        path: '/pending-approval',
        builder: (_, _) => const PendingApprovalScreen(),
      ),
      GoRoute(
        path: '/account-declined',
        builder: (_, _) => const AccountDeclinedScreen(),
      ),
      GoRoute(
        path: '/super-admin/approvals',
        builder: (_, _) => const SuperAdminApprovalsScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, _) => const OnboardingScreen(),
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
          showEdit: true,
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
      ..listen(authStateStreamProvider, (_, next) {
        // Only refresh routing on identity changes — NOT on token refreshes or
        // user-metadata updates. A spurious refresh makes GoRouter rebuild from
        // the current URI, discarding imperative `push` history; `pop()`/back
        // then throws "nothing to pop" mid-form (e.g. admin add-salesman, where
        // invoking an Edge Function can trigger a background token refresh).
        final event = next.asData?.value.event;
        if (event == AuthChangeEvent.signedIn ||
            event == AuthChangeEvent.signedOut) {
          notifyListeners();
        }
      })
      ..listen(currentAppUserProvider, (_, _) => notifyListeners())
      ..listen(mySignupRequestProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;
    final path = state.matchedLocation;

    // Splash handles its own navigation after the timer — never redirect away.
    if (path == '/splash') return null;

    // Public paths accessible without a session.
    const publicPaths = ['/login', '/signup', '/verify-email'];
    if (!isLoggedIn) {
      return publicPaths.contains(path) ? null : '/login';
    }

    final userAsync = _ref.read(currentAppUserProvider);

    // Still resolving identity — stay put to avoid a premature redirect.
    if (userAsync.isLoading) return null;

    final user = userAsync.asData?.value;

    // Logged in but no provisioned `users` row → an unapproved distributor.
    // Route to the pending / declined screen based on their request status.
    if (user == null) {
      final reqAsync = _ref.read(mySignupRequestProvider);
      if (reqAsync.isLoading) return null;

      final target = reqAsync.asData?.value?.status ==
              SignupRequestStatus.rejected
          ? '/account-declined'
          : '/pending-approval';
      return path == target ? null : target;
    }

    // Provisioned but disabled (e.g. a super admin revoked an approved account,
    // or an admin deactivated a salesman) → same dead-end as a declined signup.
    if (!user.isActive) {
      return path == '/account-declined' ? null : '/account-declined';
    }

    final isSuperAdmin = user.role == UserRole.superAdmin;
    final isAdmin = user.role == UserRole.admin;
    final isSalesman = user.role == UserRole.salesman;

    // Provisioned users never belong on the signup / account-status screens.
    const limboPaths = [
      '/login',
      '/signup',
      '/verify-email',
      '/pending-approval',
      '/account-declined',
    ];
    String homeFor() => isSuperAdmin
        ? '/super-admin/approvals'
        : (isAdmin ? '/admin/dashboard' : '/home');

    if (limboPaths.contains(path)) return homeFor();

    // Super admin lives only in the /super-admin area.
    if (isSuperAdmin) {
      return path.startsWith('/super-admin') ? null : '/super-admin/approvals';
    }
    // Everyone else is kept out of it.
    if (path.startsWith('/super-admin')) return homeFor();

    // /onboarding is admin-only but not under /admin — let it through.
    if (path == '/onboarding') {
      return isAdmin ? null : '/home';
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
