import 'dart:async';

import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_text_field.dart';
import 'package:distro_link/features/catalog/application/admin_product_providers.dart';
import 'package:distro_link/features/catalog/domain/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const List<double> _gstSlabs = [0, 5, 18, 40];

class AddEditProductScreen extends ConsumerStatefulWidget {
  const AddEditProductScreen({super.key, this.product});
  final Product? product;

  @override
  ConsumerState<AddEditProductScreen> createState() =>
      _AddEditProductScreenState();
}

class _AddEditProductScreenState extends ConsumerState<AddEditProductScreen> {
  late final TextEditingController _code;
  late final TextEditingController _name;
  late final TextEditingController _mrp;
  late final TextEditingController _baseRate;
  late double _gstPercent;
  late bool _isActive;
  bool _loading = false;
  String? _error;

  bool get _isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _code = TextEditingController(text: p?.itemCode ?? '');
    _name = TextEditingController(text: p?.itemName ?? '');
    _mrp = TextEditingController(
      text: p != null ? p.mrp.toStringAsFixed(2) : '',
    );
    _baseRate = TextEditingController(
      text: p != null ? p.baseRate.toStringAsFixed(2) : '',
    );
    _gstPercent = p?.gstPercent ?? 0;
    _isActive = p?.isActive ?? true;

    if (!_isEdit) {
      unawaited(
        Future.microtask(() async {
          final code = await ref.read(nextProductItemCodeProvider.future);
          if (mounted && _code.text.isEmpty) {
            setState(() => _code.text = code);
          }
        }),
      );
    }
  }

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    _mrp.dispose();
    _baseRate.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _code.text.trim();
    final name = _name.text.trim();
    final mrp = double.tryParse(_mrp.text.trim()) ?? -1;
    final baseRate = double.tryParse(_baseRate.text.trim()) ?? -1;

    if (code.isEmpty || name.isEmpty) {
      setState(() => _error = 'Item code and name are required.');
      return;
    }
    if (mrp <= 0 || baseRate <= 0) {
      setState(() => _error = 'MRP and selling rate must be positive numbers.');
      return;
    }
    if (baseRate > mrp) {
      setState(() => _error = 'Selling rate cannot exceed MRP.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final notifier = ref.read(adminProductsListProvider.notifier);
      if (_isEdit) {
        await notifier.updateProduct(
          id: widget.product!.id,
          itemCode: code,
          itemName: name,
          mrp: mrp,
          baseRate: baseRate,
          gstPercent: _gstPercent,
          isActive: _isActive,
        );
      } else {
        await notifier.create(
          itemCode: code,
          itemName: name,
          mrp: mrp,
          baseRate: baseRate,
          gstPercent: _gstPercent,
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
                    _isEdit ? 'Edit Product' : 'Add Product',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
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
                    AppTextField(
                      controller: _code,
                      label: 'Item Code',
                      hint: 'Generating…',
                      readOnly: !_isEdit,
                      prefixIcon: !_isEdit
                          ? const Icon(Icons.lock_outline, size: 16)
                          : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(
                      controller: _name,
                      label: 'Item Name',
                      hint: 'e.g. Sunflower Oil 1L',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _mrp,
                            label: 'MRP (₹)',
                            hint: '0.00',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: AppTextField(
                            controller: _baseRate,
                            label: 'Selling Rate (₹)',
                            hint: '0.00',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text('GST Slab', style: theme.textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.xs / 2),
                    DropdownButtonFormField<double>(
                      key: ValueKey(_gstPercent),
                      initialValue: _gstPercent,
                      decoration: const InputDecoration(),
                      items: _gstSlabs
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text('${s.toStringAsFixed(0)}%'),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _gstPercent = v ?? _gstPercent),
                    ),
                    if (_isEdit) ...[
                      const SizedBox(height: AppSpacing.sm),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Active',
                          style: theme.textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          'Inactive products are hidden from salesmen.',
                          style: theme.textTheme.bodySmall,
                        ),
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                      ),
                    ],
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
                      label: _isEdit ? 'Save Changes' : 'Add Product',
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
