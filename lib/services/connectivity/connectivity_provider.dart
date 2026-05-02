import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<ConnectivityResult>> connectivity(Ref ref) =>
    Connectivity().onConnectivityChanged;

/// True when the device has any network connection.
@Riverpod(keepAlive: true)
bool isOnline(Ref ref) {
  final result = ref.watch(connectivityProvider).asData?.value;
  if (result == null) return true; // assume online until we know otherwise
  return result.any((r) => r != ConnectivityResult.none);
}
