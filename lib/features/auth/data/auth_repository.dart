import 'package:distro_link/features/auth/domain/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  const AuthRepository(this._client);
  final SupabaseClient _client;

  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) =>
      _client.auth.signInWithPassword(email: email, password: password);

  Future<void> signOut() => _client.auth.signOut();

  Stream<AuthState> authStateChanges() => _client.auth.onAuthStateChange;

  User? get currentAuthUser => _client.auth.currentUser;

  /// Fetches the [AppUser] row that matches the currently signed-in auth user.
  /// Returns null when not signed in or when no users row exists yet.
  Future<AppUser?> currentAppUser() async {
    final auth = currentAuthUser;
    if (auth == null) return null;
    final data = await _client
        .from('users')
        .select()
        .eq('auth_user_id', auth.id)
        .maybeSingle();
    return data == null ? null : AppUser.fromJson(data);
  }

  /// Fetches the [Salesman] row linked to the given [userId] (users.id).
  /// Used after login to resolve the salesman entity id for order creation.
  Future<Salesman?> salesmanForUser(String userId) async {
    final data = await _client
        .from('salesmen')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    return data == null ? null : Salesman.fromJson(data);
  }
}
