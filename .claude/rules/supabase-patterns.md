# Supabase Patterns

Schema is in [database.md](./database.md). This file documents **how** we talk to Supabase from Dart.

## Initialisation

Supabase client is initialised once in `bootstrap.dart` before `runApp`:

```dart
// lib/bootstrap.dart
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
}
```

`Env` is a thin typed accessor over `dotenv.env`:

```dart
// lib/core/config/env.dart
abstract final class Env {
  static String get supabaseUrl =>
      dotenv.env['SUPABASE_URL'] ?? (throw StateError('SUPABASE_URL missing'));
  static String get supabaseAnonKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ?? (throw StateError('SUPABASE_ANON_KEY missing'));
}
```

`.env.example` is committed (placeholder values); `.env` is in `.gitignore`.

## Client access — via Riverpod, not directly

Don't reach for `Supabase.instance.client` from feature code. Expose it once and inject everywhere else:

```dart
// lib/core/network/supabase_provider.dart
@riverpod
SupabaseClient supabaseClient(Ref ref) => Supabase.instance.client;
```

Repositories take the client via constructor injection (kept testable):

```dart
@riverpod
ShopsRepository shopsRepository(Ref ref) =>
    ShopsRepository(ref.watch(supabaseClientProvider));
```

## Repository layer — pattern

One repository per resource. Keeps Supabase-isms out of the UI.

```dart
class ShopsRepository {
  ShopsRepository(this._client);
  final SupabaseClient _client;

  Future<List<Shop>> listByArea(String areaId) async {
    final rows = await _client
        .from('shops')
        .select()
        .eq('area_id', areaId)
        .order('shop_name');
    return rows.map(Shop.fromJson).toList();
  }

  Future<List<Shop>> recentForSalesman(String salesmanId, {int limit = 5}) async {
    final rows = await _client
        .from('orders')
        .select('shop_id, created_at, shops!inner(*)')
        .eq('salesman_id', salesmanId)
        .order('created_at', ascending: false)
        .limit(limit * 4); // overfetch to dedupe shop_id
    final seen = <String>{};
    final shops = <Shop>[];
    for (final row in rows) {
      final shop = Shop.fromJson(row['shops'] as Map<String, dynamic>);
      if (seen.add(shop.id)) shops.add(shop);
      if (shops.length >= limit) break;
    }
    return shops;
  }
}
```

**Rules:**
- Repository methods return **domain models**, never raw `Map<String, dynamic>`.
- All `from('table').select(...).order(...).eq(...)` chains live in the repo. UI/providers see typed Dart only.
- One method = one logical query. Don't combine unrelated queries inside a repo method.
- Repos are stateless (no caching) — the cache layer is Riverpod / Isar (Phase 2).

## Auth — pattern

Use Supabase Auth directly; do not reinvent.

```dart
class AuthRepository {
  AuthRepository(this._client);
  final SupabaseClient _client;

  Future<void> signInWithPassword({required String email, required String password}) =>
      _client.auth.signInWithPassword(email: email, password: password);

  Future<void> signOut() => _client.auth.signOut();

  Stream<AuthState> authStateChanges() => _client.auth.onAuthStateChange;

  User? get currentUser => _client.auth.currentUser;

  Future<AppUser?> currentAppUser() async {
    final auth = currentUser;
    if (auth == null) return null;
    final row = await _client
        .from('users')
        .select()
        .eq('auth_user_id', auth.id)
        .maybeSingle();
    return row == null ? null : AppUser.fromJson(row);
  }
}
```

In Riverpod:

```dart
@riverpod
Stream<AuthState> authState(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges();

@riverpod
Future<AppUser?> currentAppUser(Ref ref) async {
  ref.watch(authStateProvider); // re-fetch on auth changes
  return ref.watch(authRepositoryProvider).currentAppUser();
}
```

Route guard reads `currentAppUserProvider` — see [riverpod-patterns.md](./riverpod-patterns.md) and `lib/app/router.dart`.

## Inserts — atomicity

When you need to insert a parent + children atomically (e.g. `orders` + `order_items`), prefer one of these:

1. **Postgres function (RPC) on the server** — best. The function runs in a single transaction. Call it via `_client.rpc('create_order', params: {...})`. **Ask the user** if they want to add this.
2. **Insert parent → use returned id → batch-insert children.** Acceptable when the children insert is idempotent or recoverable. Pattern:

```dart
Future<String> submit(OrderDraft draft) async {
  final order = await _client
      .from('orders')
      .insert(draft.toOrderJson())
      .select('id')
      .single();
  final orderId = order['id'] as String;
  await _client.from('order_items').insert(
    draft.items.map((it) => it.toJson(orderId: orderId)).toList(),
  );
  return orderId;
}
```

If the second insert fails, the parent row is orphaned. **Acceptable for Phase 1**; Phase 2 should move to RPC.

## Errors

Supabase throws `PostgrestException` for query errors and `AuthException` for auth errors.

- **Repository layer** — let exceptions propagate. Don't catch-and-rethrow generic strings.
- **Provider layer** — exceptions surface as `AsyncValue.error`. Render via `.when(error: ...)` in the UI.
- **UI** — show user-friendly messages. Map known codes (e.g. invalid creds) to specific copy; fall back to "Something went wrong. Please try again." Log the original via `logger`.

## RLS & defence-in-depth

The app **assumes** RLS is enforced server-side (see `database.md` § RLS). Never trust client-only filtering for permissions. But also: filter client-side as a UX measure (don't ask the server for things you know you can't have).

## Realtime

Not used in Phase 1. If you reach for `_client.channel(...)`, ask first — there are simpler alternatives (`ref.invalidate`, pull-to-refresh).

## Things to never do

- ❌ Direct `Supabase.instance.client` usage outside repos / `supabaseClientProvider`.
- ❌ Raw `Map<String, dynamic>` returned from a repo.
- ❌ `try { ... } catch (_) { return []; }` — silently swallowing errors.
- ❌ Custom JWT or password handling.
- ❌ Long `.select(...)` strings in widget files.
