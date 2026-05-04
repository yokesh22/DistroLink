import 'package:distro_link/services/hive/hive_service.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hive_provider.g.dart';

@Riverpod(keepAlive: true)
Future<HiveService> hiveService(Ref ref) async {
  await Hive.initFlutter();
  final areasBox = await Hive.openBox<dynamic>('areas');
  final shopsBox = await Hive.openBox<dynamic>('shops');
  final productsBox = await Hive.openBox<dynamic>('products');
  final outboxBox = await Hive.openBox<dynamic>('outbox');
  return HiveService(
    areasBox: areasBox,
    shopsBox: shopsBox,
    productsBox: productsBox,
    outboxBox: outboxBox,
  );
}
