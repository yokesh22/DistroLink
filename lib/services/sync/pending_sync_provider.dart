import 'package:distro_link/services/hive/hive_provider.dart';
import 'package:distro_link/services/hive/outbox_order.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pending_sync_provider.g.dart';

/// Live count of orders waiting to sync.
/// Updates automatically via Hive [Box.watch] whenever the outbox changes.
@Riverpod(keepAlive: true)
Stream<int> pendingSyncCount(Ref ref) async* {
  final hive = await ref.read(hiveServiceProvider.future);
  final box = hive.outboxBox;

  yield _count(box);

  await for (final BoxEvent _ in box.watch()) {
    yield _count(box);
  }
}

int _count(Box<dynamic> box) => box.values
    .where(
      (dynamic m) =>
          (m as Map<dynamic, dynamic>)['status'] ==
          OutboxStatus.pending.name,
    )
    .length;
