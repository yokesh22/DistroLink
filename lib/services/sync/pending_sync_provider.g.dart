// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Live count of orders waiting to sync.
/// Updates automatically via Hive [Box.watch] whenever the outbox changes.

@ProviderFor(pendingSyncCount)
final pendingSyncCountProvider = PendingSyncCountProvider._();

/// Live count of orders waiting to sync.
/// Updates automatically via Hive [Box.watch] whenever the outbox changes.

final class PendingSyncCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Live count of orders waiting to sync.
  /// Updates automatically via Hive [Box.watch] whenever the outbox changes.
  PendingSyncCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingSyncCountProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingSyncCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return pendingSyncCount(ref);
  }
}

String _$pendingSyncCountHash() => r'e09c1e82e8467a28280f1623618e0a1fac2db108';
