import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_text_field.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/shops/application/admin_shop_providers.dart';
import 'package:distro_link/features/shops/application/shop_providers.dart';
import 'package:distro_link/features/shops/domain/area.dart';
import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom sheet that lets a salesman add a new shop into the [area] already
/// selected in Step 1 of the order flow. Salesmen may **add** (not edit) shops
/// in their own distributor — see .claude/rules/business-rules.md (2026-07-24).
///
/// Returns the created [Shop] via `Navigator.pop`, or `null` if dismissed.
class AddShopSheet extends ConsumerStatefulWidget {
  const AddShopSheet({required this.area, super.key});

  final Area area;

  /// Opens the sheet and resolves to the created [Shop], or `null` if the
  /// salesman dismissed it without creating one.
  static Future<Shop?> show(BuildContext context, {required Area area}) {
    return showModalBottomSheet<Shop>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => AddShopSheet(area: area),
    );
  }

  @override
  ConsumerState<AddShopSheet> createState() => _AddShopSheetState();
}

class _AddShopSheetState extends ConsumerState<AddShopSheet> {
  late final TextEditingController _name;
  late final TextEditingController _number;
  late final TextEditingController _address;
  late final TextEditingController _owner;
  late final TextEditingController _phone;
  late final TextEditingController _gstin;

  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _number = TextEditingController();
    _address = TextEditingController();
    _owner = TextEditingController();
    _phone = TextEditingController();
    _gstin = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _number.dispose();
    _address.dispose();
    _owner.dispose();
    _phone.dispose();
    _gstin.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    final address = _address.text.trim();

    if (name.isEmpty || address.isEmpty) {
      setState(() => _error = 'Shop Name and Address are required.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Resolve the salesman's distributor. Fail loudly rather than sending an
      // empty string (which Postgres would reject as an invalid uuid).
      final user = await ref.read(currentAppUserProvider.future);
      final distributorId = user?.distributorId ?? '';
      if (distributorId.isEmpty) {
        setState(
          () => _error =
              "Your account isn't linked to a distributor. "
              'Please sign out and back in.',
        );
        return;
      }

      final number = _number.text.trim();
      final owner = _owner.text.trim();
      final phone = _phone.text.trim();
      final gstin = _gstin.text.trim();

      // Call the repository directly with the widget's ref (alive while the
      // sheet is mounted). Routing through AdminShopsList — an auto-dispose
      // notifier nothing watches in the order flow — disposes mid-insert and
      // throws "Cannot use Ref after it has been disposed".
      final shop = await ref.read(adminShopsRepositoryProvider).create(
            distributorId: distributorId,
            areaId: widget.area.id,
            shopName: name,
            shopAddress: address,
            shopNumber: number.isEmpty ? null : number,
            shopOwner: owner.isEmpty ? null : owner,
            phoneNo: phone.isEmpty ? null : phone,
            gstin: gstin.isEmpty ? null : gstin,
          );
      // Seed the offline cache so the offline-first listByArea (which returns
      // cached rows immediately) includes the new shop on the next read.
      final shopsRepo = await ref.read(shopsRepositoryProvider.future);
      await shopsRepo.cacheShop(shop);
      if (!mounted) return;

      // Refresh the salesman-facing shop lists so the new shop shows up.
      ref
        ..invalidate(shopsByAreaProvider)
        ..invalidate(recentShopsProvider);
      Navigator.of(context).pop(shop);
    } on Exception catch (e, st) {
      // Surface the real cause (RLS denial, bad uuid, offline, …) so it's
      // diagnosable on-device instead of a generic message.
      debugPrint('AddShopSheet.create failed: $e\n$st');
      setState(() => _error = "Couldn't save the shop: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      // Keyboard-aware: lift the sheet above the on-screen keyboard.
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grab handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Add Shop',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              // Fixed area chip — the shop is added to the selected area.
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.map_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Adding to: ${widget.area.name}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Shop Name (required)
              AppTextField(
                controller: _name,
                label: 'Retailer Name',
                hint: 'Enter retailer name...',
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.sm),

              // Retailer Code (optional)
              AppTextField(
                controller: _number,
                label: 'Retailer Code (optional)',
                hint: 'e.g. SH-042',
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.sm),

              // Address (required)
              AppTextField(
                controller: _address,
                label: 'Address',
                hint: 'Enter full address...',
                maxLines: 3,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.sm),

              // Owner (optional)
              AppTextField(
                controller: _owner,
                label: 'Owner Name (optional)',
                hint: 'Enter owner name...',
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.sm),

              // Phone (optional)
              AppTextField(
                controller: _phone,
                label: 'Phone (optional)',
                hint: '+91 ...........',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.sm),

              // GSTIN (optional)
              AppTextField(
                controller: _gstin,
                label: 'GSTIN (optional)',
                hint: '27XXXXX0000X1Z5',
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),

              if (_error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _error!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Add & Select Shop',
                loading: _loading,
                icon: Icons.add,
                onPressed: _loading ? null : _submit,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
