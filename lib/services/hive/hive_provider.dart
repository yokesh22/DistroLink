import 'package:distro_link/services/hive/hive_service.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hive_provider.g.dart';

/// Bump whenever a cached domain model's JSON shape changes (Area / Shop /
/// Product). On a version mismatch the read-through caches are cleared so stale
/// rows can't fail deserialization — e.g. areas/shops cached before the
/// `distributor_id` column existed. The outbox is user data and is never
/// cleared here.
const _cacheSchemaVersion = 2;

@Riverpod(keepAlive: true)
Future<HiveService> hiveService(Ref ref) async {
  await Hive.initFlutter();
  final areasBox = await Hive.openBox<dynamic>('areas');
  final shopsBox = await Hive.openBox<dynamic>('shops');
  final productsBox = await Hive.openBox<dynamic>('products');
  final outboxBox = await Hive.openBox<dynamic>('outbox');

  // Drop stale read-through caches on a schema bump (keeps the outbox intact).
  final metaBox = await Hive.openBox<dynamic>('cache_meta');
  final storedVersion = metaBox.get('schema_version') as int?;
  if (storedVersion != _cacheSchemaVersion) {
    await Future.wait([
      areasBox.clear(),
      shopsBox.clear(),
      productsBox.clear(),
    ]);
    await metaBox.put('schema_version', _cacheSchemaVersion);
  }

  return HiveService(
    areasBox: areasBox,
    shopsBox: shopsBox,
    productsBox: productsBox,
    outboxBox: outboxBox,
  );
}
