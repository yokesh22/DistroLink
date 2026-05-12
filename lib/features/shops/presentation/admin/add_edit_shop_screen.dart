import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_text_field.dart';
import 'package:distro_link/features/shops/application/admin_area_providers.dart';
import 'package:distro_link/features/shops/application/admin_shop_providers.dart';
import 'package:distro_link/features/shops/domain/area.dart';
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
  late final TextEditingController _owner;
  late final TextEditingController _phone;
  late final TextEditingController _gstin;

  Area? _selectedArea;
  bool _loading = false;
  String? _error;

  bool get _isEdit => widget.shop != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.shop?.shopName ?? '');
    _number = TextEditingController(text: widget.shop?.shopNumber ?? '');
    _address = TextEditingController(text: widget.shop?.shopAddress ?? '');
    _owner = TextEditingController(text: widget.shop?.shopOwner ?? '');
    _phone = TextEditingController(text: widget.shop?.phoneNo ?? '');
    _gstin = TextEditingController(text: widget.shop?.gstin ?? '');
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

  // Pre-select area when areas load (edit mode)
  void _maybePreselectArea(List<Area> areas) {
    if (_selectedArea != null || widget.shop == null) return;
    final match = areas.where((a) => a.id == widget.shop!.areaId).firstOrNull;
    if (match != null) setState(() => _selectedArea = match);
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    final address = _address.text.trim();

    if (name.isEmpty || _selectedArea == null || address.isEmpty) {
      setState(() => _error = 'Shop Name, Area, and Address are required.');
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
          areaId: _selectedArea!.id,
          shopName: name,
          shopAddress: address,
          shopNumber: _number.text.trim().isEmpty ? null : _number.text.trim(),
          shopOwner: _owner.text.trim().isEmpty ? null : _owner.text.trim(),
          phoneNo: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
          gstin: _gstin.text.trim().isEmpty ? null : _gstin.text.trim(),
        );
      } else {
        await notifier.create(
          areaId: _selectedArea!.id,
          shopName: name,
          shopAddress: address,
          shopNumber: _number.text.trim().isEmpty ? null : _number.text.trim(),
          shopOwner: _owner.text.trim().isEmpty ? null : _owner.text.trim(),
          phoneNo: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
          gstin: _gstin.text.trim().isEmpty ? null : _gstin.text.trim(),
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

    // Pre-select area in edit mode once areas are loaded
    areasAsync.whenData(_maybePreselectArea); // ignore: cascade_invocations

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
                    // Info banner
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.orangeLight,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusCard),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('💡', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'New area? Just type it in the Area field — '
                              "it's saved and assigned in one step. "
                              'No separate Areas screen needed.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFF92400E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Shop Name
                    AppTextField(
                      controller: _name,
                      label: 'Shop Name',
                      hint: 'Enter shop name...',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Shop Number
                    AppTextField(
                      controller: _number,
                      label: 'Shop Number',
                      hint: 'e.g. SH-042',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Area picker
                    Text(
                      'Area *',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    areasAsync.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text(
                        'Failed to load areas: $e',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                      data: (areas) => _AreaPickerField(
                        areas: areas,
                        selectedArea: _selectedArea,
                        onAreaSelected: (a) =>
                            setState(() => _selectedArea = a),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Address
                    AppTextField(
                      controller: _address,
                      label: 'Address',
                      hint: 'Enter full address...',
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Owner Name (optional)
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
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: _isEdit ? 'Save Changes' : 'Create Shop',
                      loading: _loading,
                      onPressed: _loading ? null : _submit,
                    ),
                    const SizedBox(height: AppSpacing.md),
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

// ---------------------------------------------------------------------------
// Custom area picker with inline search and "Add new area" creation flow
// ---------------------------------------------------------------------------

class _AreaPickerField extends ConsumerStatefulWidget {
  const _AreaPickerField({
    required this.areas,
    required this.selectedArea,
    required this.onAreaSelected,
  });

  final List<Area> areas;
  final Area? selectedArea;
  final ValueChanged<Area> onAreaSelected;

  @override
  ConsumerState<_AreaPickerField> createState() => _AreaPickerFieldState();
}

class _AreaPickerFieldState extends ConsumerState<_AreaPickerField> {
  bool _open = false;
  bool _creatingNew = false;
  bool _savingArea = false;
  final _searchCtrl = TextEditingController();
  final _newAreaCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _newAreaCtrl.dispose();
    super.dispose();
  }

  List<Area> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return widget.areas;
    return widget.areas.where((a) => a.name.toLowerCase().contains(q)).toList();
  }

  void _toggle() => setState(() {
        _open = !_open;
        if (!_open) {
          _creatingNew = false;
          _searchCtrl.clear();
          _newAreaCtrl.clear();
        }
      });

  void _select(Area a) {
    widget.onAreaSelected(a);
    setState(() {
      _open = false;
      _creatingNew = false;
      _searchCtrl.clear();
    });
  }

  Future<void> _saveNewArea() async {
    final name = _newAreaCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _savingArea = true);
    try {
      final area =
          await ref.read(adminAreasListProvider.notifier).create(name);
      if (mounted) _select(area);
    } finally {
      if (mounted) setState(() => _savingArea = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = _open
        ? AppColors.primary
        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));
    final fillColor =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Picker trigger
        GestureDetector(
          onTap: _toggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: fillColor,
              border: Border.all(
                color: borderColor,
                width: _open ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 18,
                  color: widget.selectedArea != null
                      ? AppColors.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.selectedArea?.name ?? 'Select area...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: widget.selectedArea != null
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                Icon(
                  _open
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),

        // Dropdown panel
        if (_open)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _creatingNew ? _buildCreatePanel(theme) : _buildList(theme),
          ),
      ],
    );
  }

  Widget _buildList(ThemeData theme) {
    final filtered = _filtered;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search field
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _searchCtrl,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Search areas...',
              prefixIcon: const Icon(Icons.search, size: 18),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),

        // Area list
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              'No areas found',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          )
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final area = filtered[i];
                final isSelected = widget.selectedArea?.id == area.id;
                return InkWell(
                  onTap: () => _select(area),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.bookmark_border_rounded,
                          size: 16,
                          color: isSelected
                              ? AppColors.primary
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          area.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected ? AppColors.primary : null,
                            fontWeight: isSelected ? FontWeight.w600 : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        // Divider + Add new area
        const Divider(height: 1),
        InkWell(
          onTap: () => setState(() {
            _creatingNew = true;
            _newAreaCtrl.clear();
          }),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(AppSpacing.radiusCard),
            bottomRight: Radius.circular(AppSpacing.radiusCard),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.add, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'Add new area',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreatePanel(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Create new area',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _creatingNew = false),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'The new area will be saved and assigned to this shop.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _newAreaCtrl,
            autofocus: true,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Area name',
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onSubmitted: (_) => _saveNewArea(),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _savingArea
                    ? null
                    : () => setState(() => _creatingNew = false),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              AppButton(
                label: '+ Add area',
                loading: _savingArea,
                fullWidth: false,
                onPressed: _savingArea ? null : _saveNewArea,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
