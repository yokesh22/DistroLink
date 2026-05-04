import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_text_field.dart';
import 'package:distro_link/features/shops/application/admin_area_providers.dart';
import 'package:distro_link/features/shops/application/admin_shop_providers.dart';
import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddEditShopScreen extends ConsumerStatefulWidget {
  const AddEditShopScreen({super.key, this.shop});
  final Shop? shop;

  @override
  ConsumerState<AddEditShopScreen> createState() => _AddEditShopScreenState();
}

class _AddEditShopScreenState extends ConsumerState<AddEditShopScreen> {
  late final TextEditingController _name;
  late final TextEditingController _number;
  late final TextEditingController _address;
  String? _selectedAreaId;
  bool _loading = false;
  String? _error;

  bool get _isEdit => widget.shop != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.shop?.shopName ?? '');
    _number = TextEditingController(text: widget.shop?.shopNumber ?? '');
    _address = TextEditingController(text: widget.shop?.shopAddress ?? '');
    _selectedAreaId = widget.shop?.areaId;
  }

  @override
  void dispose() {
    _name.dispose();
    _number.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    final number = _number.text.trim();
    final address = _address.text.trim();

    if (name.isEmpty ||
        number.isEmpty ||
        address.isEmpty ||
        _selectedAreaId == null) {
      setState(() => _error = 'All fields including area are required.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final notifier = ref.read(adminShopsListProvider.notifier);
      if (_isEdit) {
        await notifier.updateShop(
          id: widget.shop!.id,
          areaId: _selectedAreaId!,
          shopName: name,
          shopNumber: number,
          shopAddress: address,
        );
      } else {
        await notifier.create(
          areaId: _selectedAreaId!,
          shopName: name,
          shopNumber: number,
          shopAddress: address,
        );
      }
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
    final areasAsync = ref.watch(adminAreasListProvider);

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
                    _isEdit ? 'Edit Shop' : 'Add Shop',
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
                    // Area dropdown
                    Text('Area', style: theme.textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.xs / 2),
                    areasAsync.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text('Failed to load areas: $e'),
                      data: (areas) => DropdownButtonFormField<String>(
                        key: ValueKey(_selectedAreaId),
                        initialValue: _selectedAreaId,
                        hint: const Text('Select area'),
                        decoration: const InputDecoration(),
                        items: areas
                            .map(
                              (a) => DropdownMenuItem(
                                value: a.id,
                                child: Text(a.name),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _selectedAreaId = v),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(
                      controller: _name,
                      label: 'Shop Name',
                      hint: 'e.g. Sri Ram Stores',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(
                      controller: _number,
                      label: 'Shop Number',
                      hint: 'e.g. SH-041',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(
                      controller: _address,
                      label: 'Address',
                      hint: 'e.g. 12, Main Road, Sector 5',
                      maxLines: 2,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                    ),
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
                      label: _isEdit ? 'Save Changes' : 'Add Shop',
                      loading: _loading,
                      onPressed: _loading ? null : _submit,
                    ),
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
