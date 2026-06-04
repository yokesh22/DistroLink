// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_worker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Long-lived service that drains the outbox whenever connectivity returns.
/// Eagerly started in DistroLinkApp via `ref.read(syncWorkerProvider)`.

@ProviderFor(SyncWorker)
final syncWorkerProvider = SyncWorkerProvider._();

/// Long-lived service that drains the outbox whenever connectivity returns.
/// Eagerly started in DistroLinkApp via `ref.read(syncWorkerProvider)`.
final class SyncWorkerProvider extends $NotifierProvider<SyncWorker, void> {
  /// Long-lived service that drains the outbox whenever connectivity returns.
  /// Eagerly started in DistroLinkApp via `ref.read(syncWorkerProvider)`.
  SyncWorkerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncWorkerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncWorkerHash();

  @$internal
  @override
  SyncWorker create() => SyncWorker();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$syncWorkerHash() => r'482a43d8258a030a21f3d83990b8dc6341272f9c';

/// Long-lived service that drains the outbox whenever connectivity returns.
/// Eagerly started in DistroLinkApp via `ref.read(syncWorkerProvider)`.

abstract class _$SyncWorker extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
