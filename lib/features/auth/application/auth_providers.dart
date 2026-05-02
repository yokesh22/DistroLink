import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/auth/data/auth_repository.dart';
import 'package:distro_link/features/auth/domain/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(supabaseClientProvider));

/// Raw Supabase auth state stream — used to drive the router refresh.
@Riverpod(keepAlive: true)
Stream<AuthState> authStateStream(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges();

/// The current app-level user record. Re-fetched whenever auth state changes.
@Riverpod(keepAlive: true)
Future<AppUser?> currentAppUser(Ref ref) async {
  // Re-run whenever auth changes (login / logout).
  ref.watch(authStateStreamProvider);
  return ref.watch(authRepositoryProvider).currentAppUser();
}

/// The [Salesman] entity for the currently logged-in salesman.
/// Null when the user is not a salesman or no salesman row exists.
@Riverpod(keepAlive: true)
Future<Salesman?> currentSalesman(Ref ref) async {
  final user = await ref.watch(currentAppUserProvider.future);
  if (user == null || user.role != UserRole.salesman) return null;
  return ref.watch(authRepositoryProvider).salesmanForUser(user.id);
}
