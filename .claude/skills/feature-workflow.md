# Feature Development Workflow

Follow this when adding any new feature, screen, or non-trivial change. The user is the PM; you are the junior dev — checkpoint with them at the right moments.

## 0. Understand the request

- Is it covered by [product.md](./product.md) phase scope? If it's Phase 2+ work being requested in Phase 1, **flag it** and ask whether to defer or pull forward.
- Does it conflict with any [business-rules.md](./business-rules.md) or [ui-rules.md](./ui-rules.md)? If yes, surface the conflict.
- Is it visible in the design wireframe? If yes, **read the relevant screen carefully** before designing.
- Does it need a schema change? If yes, **stop and ask** — the user owns the Supabase schema.

## 1. Plan before code (for anything non-trivial)

- For >1 file or >50 LoC, write a short plan (a few bullets — the question to answer, the files that will change, any open questions). Use the planning workflow if the user invoked plan mode.
- Identify reuse: existing widgets in `lib/core/widgets/`, repos in `lib/features/*/data/`, providers in `lib/features/*/application/`. **Don't write new ones if an existing one fits** — extend instead.
- Confirm the data path end-to-end: which Supabase tables, which repository method, which provider, which screen.

## 2. Layer the work top-down

For a new screen "X" in feature `<feature>`:

```
lib/features/<feature>/
  domain/
    x_state.dart            # if the screen has mutable state
    <model>.dart            # freezed + JSON if a new model is needed
  data/
    <feature>_repository.dart   # add a method (or new file if a new resource)
  application/
    x_providers.dart        # add the providers that back the screen
  presentation/
    x_screen.dart           # the widget itself
    widgets/                # screen-private widgets (only if reused inside the feature)
```

Cross-feature reusable widgets graduate to `lib/core/widgets/`.

## 3. File-by-file checklist

### Models
- `freezed` + `json_serializable`.
- `fromJson` matches the Supabase column names exactly (use `@JsonKey(name: 'snake_case')` if Dart field is camelCase).
- Add a doc comment if the model has business invariants.

### Repository methods
- Take inputs as typed Dart, return typed domain models (never `Map`).
- One responsibility per method; one Supabase chain per method.
- Don't catch and rewrap errors with generic strings — let them propagate.
- Pattern reference: [supabase-patterns.md](./supabase-patterns.md).

### Providers
- `@riverpod` codegen.
- Naming: noun, not verb. (`recentOrders`, not `getRecentOrders`.)
- Three-layer separation: infra (`supabaseClientProvider`), repo (`*RepositoryProvider`), state (everything else).
- Pattern reference: [riverpod-patterns.md](./riverpod-patterns.md).

### Screens
- Use existing wrappers (`AppButton`, `AppCard`, `AppTextField`, `AppStatCard`, ...).
- Use tokens (`AppColors`, `AppSpacing`, `AppTypography`).
- Handle all three `AsyncValue` states (`data`, `loading`, `error`).
- Add the route to `lib/app/router.dart`.
- Add to bottom nav if it's a top-level tab.
- Pattern reference: [ui-rules.md](./ui-rules.md).

### Routing
- Update `lib/app/router.dart` with the new path.
- If guarded, ensure the redirect logic checks role / auth.

### Tests
- For a new shared widget: a smoke widget test (renders, basic interaction).
- For business logic (e.g. order draft math, validation): unit tests with concrete examples.
- For a route guard change: a router test.
- Mock at the **repository** layer (`mocktail`), not at the Supabase client.
- Don't test framework code or codegen.

### Codegen
- Run `dart run build_runner watch -d` in a side terminal during dev (or `dart run build_runner build --delete-conflicting-outputs` once).
- Don't commit `*.g.dart` / `*.freezed.dart` edits made by hand.

## 4. Local verification

```bash
flutter analyze         # must be clean under very_good_analysis
flutter test            # must pass
flutter run -d <device> # run the actual feature in the actual app
```

For UI work: **run the app and exercise the feature in a simulator or device** — golden-path + 1-2 edge cases. Type checks and tests verify code, not UX. If you can't run the app (sandbox restrictions), say so explicitly in the report.

## 5. Documentation

Update **only** the docs that are now wrong:

- `.claude/<file>.md` — if you established a new pattern, document it.
- `docs/architecture.md` — if you changed structure (new feature, new layer).
- `docs/decisions/<NNNN>-<title>.md` — for any material decision (new tech, new pattern, new constraint). Number the next ADR; supersede prior ADRs explicitly.
- `docs/design-system.md` — if you added a token or a component.

Don't touch docs that are unchanged — and don't write a "what I did today" doc. The PR description is for that.

## 6. Commit hygiene

- Small, focused commits when you can; one feature = one commit is fine.
- Commit message: short imperative title + a body that explains *why* (the diff shows *what*).
- **Never** commit `.env`, secrets, codegen-only files (they're generated), or large binaries.

## 7. Hand-off

When a feature is done, end your reply with:
- **What changed** (one or two sentences).
- **What to test** (golden path + edges in 3-5 bullets).
- **What's deferred** (TODOs, follow-ups, gaps — link them to the relevant phase).

If the work has a natural future follow-up (e.g. "Phase 2 will swap this stub for Isar"), note it.

## Common anti-patterns to avoid

- ❌ Adding a feature ahead of requirements ("we'll need this later").
- ❌ Stubbing a screen that does nothing useful — better to skip it and add a route guard.
- ❌ Hard-coding sample data for "now, will fix later" — use real Supabase or skip the screen.
- ❌ Skipping the repository layer ("just one quick query in the widget").
- ❌ Writing a custom widget when a themed built-in works.
- ❌ Forgetting to invalidate dependent providers after a mutation.
- ❌ Catching exceptions to silence them; log and re-raise instead.
- ❌ Editing generated files; re-run codegen.
- ❌ Long PRs: prefer multiple smaller PRs aligned to the phase ladder.
