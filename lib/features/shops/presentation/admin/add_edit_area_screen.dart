import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_text_field.dart';
import 'package:distro_link/features/shops/application/admin_area_providers.dart';
import 'package:distro_link/features/shops/domain/area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddEditAreaScreen extends ConsumerStatefulWidget {
  const AddEditAreaScreen({super.key, this.area});

  /// Non-null when editing an existing area.
  final Area? area;

  @override
  ConsumerState<AddEditAreaScreen> createState() => _AddEditAreaScreenState();
}

class _AddEditAreaScreenState extends ConsumerState<AddEditAreaScreen> {
  late final TextEditingController _name;
  bool _loading = false;
  String? _error;

  bool get _isEdit => widget.area != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.area?.name ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Area name is required.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final notifier = ref.read(adminAreasListProvider.notifier);
      if (_isEdit) {
        await notifier.updateArea(widget.area!.id, name);
      } else {
        await notifier.create(name);
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
                    _isEdit ? 'Edit Area' : 'Add Area',
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
                    AppTextField(
                      controller: _name,
                      label: 'Area Name',
                      hint: 'e.g. Sector 12',
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      errorText: _error,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: _isEdit ? 'Save Changes' : 'Add Area',
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
