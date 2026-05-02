# Riverpod Patterns

Riverpod 3.x with `riverpod_annotation` codegen. Run `dart run build_runner watch -d` during development. Never hand-edit `*.g.dart`.

> Note: `riverpod_lint` is intentionally not installed yet — see [`docs/setup.md`](../docs/setup.md) for the reason. Re-add when version-compatible.

## Layered providers

Each feature has providers in `lib/features/<feature>/application/`. Three layers, top down:

1. **Infrastructure providers** — `supabaseClientProvider` in `core/network/`. Inject low-level clients.
2. **Repository providers** — one per resource: `authRepositoryProvider`, `shopsRepositoryProvider`. Trivial wiring; usually one line.
3. **State providers** — what the UI reads: `currentAppUserProvider`, `recentShopsProvider`, `salesmanStatsProvider`, `orderDraftProvider`.

UI **never** reaches past layer 3. UI **never** imports a repository directly.

## Codegen patterns

**Read-only async data:**

```dart
@riverpod
Future<List<Area>> areas(Ref ref) {
  return ref.watch(areasRepositoryProvider).listAll();
}
```

**Parameterised queries** — prefer the explicit name; codegen handles family generation:

```dart
@riverpod
Future<List<Shop>> shopsByArea(Ref ref, String areaId) {
  return ref.watch(shopsRepositoryProvider).listByArea(areaId);
}
```

**Mutable in-app state (e.g. order draft)** — use a `Notifier`:

```dart
@riverpod
class OrderDraft extends _$OrderDraft {
  @override
  OrderDraftState build() => OrderDraftState.empty();

  void selectShop({required Area area, required Shop shop}) {
    state = state.copyWith(area: area, shop: shop);
  }

  void addItem(Product p) { /* ... */ }
  void changeQty(String productId, int delta) { /* ... */ }
  void changeRate(String productId, num rate) { /* ... */ }
  void clear() => state = OrderDraftState.empty();
}
```

**Streams** — for `authState`:

```dart
@riverpod
Stream<AuthState> authStateStream(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges();
```

## Naming

- Provider name = camelCase noun matching the data it produces (`recentOrders`, not `getRecentOrders`).
- Repository providers end in `Repository` (`shopsRepositoryProvider` after codegen).
- Notifier providers end in the state name (`OrderDraftProvider`).
- Generated file is `<feature>_providers.g.dart`.

## `ref.watch` vs `ref.read` vs `ref.listen`

- **`ref.watch`** — inside `build` of a widget or another provider. Triggers rebuilds.
- **`ref.read`** — inside callbacks (`onPressed`, `onTap`, async lambdas). Never inside `build`.
- **`ref.listen`** — for side effects (snackbars, navigation) that fire on a change. Use sparingly.

## AsyncValue handling

Always handle all three states.

```dart
final shops = ref.watch(shopsByAreaProvider(areaId));
return shops.when(
  data: (list) => _ShopList(list),
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (e, st) => _ErrorView(error: e, onRetry: () => ref.invalidate(shopsByAreaProvider(areaId))),
);
```

For UI that has skeleton states or "previous data" requirements, prefer `.maybeWhen` or `valueOrNull` plus an explicit overlay — but document why.

## Invalidation

After a mutation that changes server state, invalidate the readers:

```dart
await ref.read(ordersRepositoryProvider).submit(draft);
ref.invalidate(recentOrdersProvider);
ref.invalidate(salesmanStatsProvider);
ref.invalidate(recentShopsProvider);
```

Use `invalidate` (not `refresh`) unless you need the new value synchronously.

## Auto-dispose & keeping state

Codegen-generated providers are **auto-dispose by default** in Riverpod 3.x. For state that must outlive a widget (e.g. `currentAppUserProvider`, `themeModeProvider`), set `keepAlive: true`:

```dart
@Riverpod(keepAlive: true)
Future<AppUser?> currentAppUser(Ref ref) async { ... }
```

Order draft is auto-dispose so leaving the flow clears it; consider explicitly `keepAlive` only if you support resuming a partial draft (Phase 2 with offline persistence).

## Routing integration

`go_router` reads auth state via `refreshListenable`. Bridge:

```dart
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = GoRouterRefreshNotifier();
  ref.listen(authStateStreamProvider, (_, __) => notifier.notifyListeners());
  return GoRouter(
    refreshListenable: notifier,
    redirect: (ctx, state) {
      final user = ref.read(currentAppUserProvider).valueOrNull;
      // ... gate logic
    },
    routes: [...],
  );
});
```

## Testing

Override providers in tests via `ProviderScope(overrides: [...])`. Mock the **repository** layer with `mocktail`, not the Supabase client — that keeps tests fast and decoupled from the SDK.

```dart
final mockRepo = MockShopsRepository();
when(() => mockRepo.listByArea(any())).thenAnswer((_) async => [fakeShop]);
ProviderScope(overrides: [shopsRepositoryProvider.overrideWithValue(mockRepo)], child: ...);
```

## Things to never do

- ❌ `setState` in production widgets (except for ephemeral UI controllers).
- ❌ `ref.read` inside `build`.
- ❌ Reaching past the provider layer (UI calling repos directly).
- ❌ Hand-editing `*.g.dart`.
- ❌ Sharing global mutable state outside providers.
- ❌ Catching errors inside a provider only to wrap them in a fake `AsyncValue.data`.
