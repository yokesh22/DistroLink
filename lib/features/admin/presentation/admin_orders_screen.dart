import 'dart:async';

import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/utils/money.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/core/widgets/app_chip.dart';
import 'package:distro_link/features/admin/application/admin_order_providers.dart';
import 'package:distro_link/features/auth/application/admin_salesman_providers.dart';
import 'package:distro_link/features/orders/domain/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AdminOrdersScreen extends ConsumerStatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  ConsumerState<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends ConsumerState<AdminOrdersScreen> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  List<Order> _orders = [];
  String? _salesmanId;
  String _search = '';
  int _dateFilterIndex = 0;
  int _page = 0;
  int _requestGeneration = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        _loadPage(page: 0, replace: true, generation: _requestGeneration),
      );
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final salesmenAsync = ref.watch(adminSalesmenListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.xs,
              AppSpacing.screenPadding,
              0,
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search shop or order number',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                  onChanged: _onSearchChanged,
                ),
                const SizedBox(height: AppSpacing.xs),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        [
                          'All',
                          'Today',
                          'This Week',
                        ].asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              right: AppSpacing.xs,
                            ),
                            child: AppChip(
                              label: entry.value,
                              active: _dateFilterIndex == entry.key,
                              onTap: () => _selectDateFilter(entry.key),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                salesmenAsync.when(
                  data: (salesmen) => DropdownButtonFormField<String>(
                    initialValue: _salesmanId ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Salesman',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: '',
                        child: Text('All salesmen'),
                      ),
                      ...salesmen.map(
                        (salesman) => DropdownMenuItem(
                          value: salesman.id,
                          child: Text(
                            '${salesman.name}'
                            '${salesman.isActive ? '' : ' (inactive)'}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(
                        () => _salesmanId = value == null || value.isEmpty
                            ? null
                            : value,
                      );
                      unawaited(_reload());
                    },
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (error, _) => Text(
                    'Failed to load salesmen: $error',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _reload,
              child: _buildOrdersList(theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(ThemeData theme) {
    if (_isLoading && _orders.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 180),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (_error != null && _orders.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text('Failed to load orders: $_error'),
          TextButton.icon(
            onPressed: _reload,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      );
    }

    if (_orders.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 100),
          Center(
            child: Text(
              'No orders found.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        0,
        AppSpacing.screenPadding,
        AppSpacing.md,
      ),
      itemCount: _orders.length + (_hasMore ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (context, index) {
        if (index == _orders.length) {
          return Center(
            child: _error == null
                ? TextButton.icon(
                    onPressed: _isLoading ? null : _loadMore,
                    icon: _isLoading
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.expand_more_rounded),
                    label: Text(_isLoading ? 'Loading…' : 'Load more'),
                  )
                : TextButton.icon(
                    onPressed: _isLoading ? null : _loadMore,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry loading more'),
                  ),
          );
        }
        return _AdminOrderCard(order: _orders[index]);
      },
    );
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _search = value.trim();
      unawaited(_reload());
    });
  }

  void _selectDateFilter(int index) {
    if (_dateFilterIndex == index) return;
    setState(() => _dateFilterIndex = index);
    unawaited(_reload());
  }

  Future<void> _reload() {
    final generation = ++_requestGeneration;
    setState(() {
      _orders = [];
      _page = 0;
      _isLoading = false;
      _hasMore = true;
      _error = null;
    });
    return _loadPage(page: 0, replace: true, generation: generation);
  }

  Future<void> _loadMore() => _loadPage(
    page: _page + 1,
    generation: _requestGeneration,
  );

  Future<void> _loadPage({
    required int page,
    required int generation,
    bool replace = false,
  }) async {
    if (_isLoading || !mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime? from;
    DateTime? before;
    if (_dateFilterIndex == 1) {
      from = today;
      before = today.add(const Duration(days: 1));
    } else if (_dateFilterIndex == 2) {
      from = today.subtract(Duration(days: today.weekday - 1));
      before = today.add(const Duration(days: 1));
    }

    try {
      final rows = await ref.read(
        adminOrdersPageProvider(
          page: page,
          salesmanId: _salesmanId,
          from: from,
          before: before,
          search: _search,
        ).future,
      );
      if (!mounted || generation != _requestGeneration) return;
      setState(() {
        final pageRows = rows.take(adminOrderPageSize).toList();
        if (replace) {
          _orders = pageRows;
        } else {
          _orders = [..._orders, ...pageRows];
        }
        _page = page;
        _hasMore = rows.length > adminOrderPageSize;
        _isLoading = false;
      });
    } on Exception catch (error) {
      if (!mounted || generation != _requestGeneration) return;
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }
}

class _AdminOrderCard extends StatelessWidget {
  const _AdminOrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: () => context.push('/admin/orders/${order.id}'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.shopName ?? 'Shop',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${order.orderNumber} · '
                  '${DateFormat('dd MMM yyyy').format(order.orderDate)}',
                  style: theme.textTheme.bodySmall,
                ),
                if (order.salesmanName != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    order.salesmanName!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatMoney(order.grandTotal),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
