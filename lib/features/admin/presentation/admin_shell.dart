import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({
    required this.location,
    required this.child,
    super.key,
  });

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.colorScheme.onSurface.withValues(alpha: 0.5);

    var currentIndex = 0;
    if (location.startsWith('/admin/salesmen')) currentIndex = 1;
    if (location.startsWith('/admin/shops')) currentIndex = 2;
    if (location.startsWith('/admin/products')) currentIndex = 3;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) {
          const paths = [
            '/admin/dashboard',
            '/admin/salesmen',
            '/admin/shops',
            '/admin/products',
          ];
          context.go(paths[i]);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded, color: secondary),
            selectedIcon: Icon(Icons.grid_view_rounded, color: primary),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline_rounded, color: secondary),
            selectedIcon:
                Icon(Icons.people_rounded, color: primary),
            label: 'Salesmen',
          ),
          NavigationDestination(
            icon: Icon(Icons.store_outlined, color: secondary),
            selectedIcon: Icon(Icons.store_rounded, color: primary),
            label: 'Shops',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined, color: secondary),
            selectedIcon:
                Icon(Icons.inventory_2_rounded, color: primary),
            label: 'Products',
          ),
        ],
      ),
    );
  }
}
