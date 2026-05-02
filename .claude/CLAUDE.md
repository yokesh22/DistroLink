# DistroLink — Project Memory

DistroLink is a Flutter mobile app for FMCG distributors. Salesmen visit shops in their assigned areas, take orders product-by-product, and submit them to **Supabase** (with offline-first capability planned via Isar). Admins manage the catalog (salesmen, shops, products); super admins manage distributors.

> **Active plan: [phase-1-plan.md](./phase-1-plan.md)** — read this first when starting or resuming work. It has the locked-in decisions, the unticked checklist, and the resume instructions.

## Stack

| Layer | Choice |
|---|---|
| App framework | Flutter (Android API 26+ / iOS only) |
| State | Riverpod (`flutter_riverpod` + `riverpod_annotation` codegen) |
| Routing | `go_router` |
| Backend | **Supabase** (auth + postgres + storage); Google Sheets is **deprecated** as backend |
| Offline cache | **Isar** (Phase 2) |
| Forms | `reactive_forms` |
| Connectivity | `connectivity_plus` |
| Codegen | `freezed`, `json_serializable`, `riverpod_generator`, `build_runner` |
| Lints | `very_good_analysis` (strict) |
| Excel export | `excel` package (Phase 2) |

## Memory index — read the relevant file, don't re-derive

- **[phase-1-plan.md](./phase-1-plan.md) — active plan + progress checklist (start here)**
- **[roadmap.md](./roadmap.md) — full 6-phase path from current state to wireframe-complete**
- [product.md](./product.md) — what DistroLink is, personas, scope phases
- [database.md](./database.md) — Supabase schema, columns, FKs, business invariants
- [business-rules.md](./business-rules.md) — role permissions, validation, GST math
- [ui-rules.md](./ui-rules.md) — design tokens + wrappers + UX principles
- [supabase-patterns.md](./supabase-patterns.md) — auth, repos, queries, errors
- [riverpod-patterns.md](./riverpod-patterns.md) — providers, codegen, AsyncValue
- [offline-sync-patterns.md](./offline-sync-patterns.md) — Isar cache + outbox (Phase 2)
- [feature-workflow.md](./feature-workflow.md) — step-by-step to add a feature

The public living spec lives in [`docs/`](../docs/) (`architecture.md`, `setup.md`, `decisions/`). `.claude/` is Claude's working memory — `docs/` is the human-facing source of truth. **Keep them in sync** when you change a decision.

## Hard rules

1. **Supabase is the source of truth at runtime.** No mock data in production code. Test doubles are fine inside `test/`.
2. **Tokens, not literals.** Always use `AppColors`, `AppSpacing`, `AppTypography` — extend the token set if you need a new value. Never hard-code a hex or a px.
3. **Production-grade.** `flutter analyze` clean under `very_good_analysis`. Real tests for non-trivial logic. Feature-sliced architecture (`features/<feature>/{domain,data,application,presentation}`).
4. **Build incrementally.** Present plans before larger work. Don't invent features ahead of requirements. The user is the PM; ask when uncertain.
5. **Offline-first mindset.** Salesmen work in shops with poor connectivity. Forms must never block on the network if a draft can be saved locally (Phase 2 wires this up; Phase 1 designs around it).
6. **Features never import each other.** Cross-feature concerns live in `core/` or `services/`.
7. **No `setState` in production widgets** except for ephemeral UI state (controllers, animations). State management is Riverpod.
8. **Don't hand-edit codegen output** (`*.freezed.dart`, `*.g.dart`). Re-run `build_runner` instead.

## Current phase: Phase 1 (Salesman flow)

Implementing: Login (email+password via Supabase Auth) → Salesman Dashboard → 4-step Order Flow (Area+Shop → Details → Items → Bill Preview) → Orders List → Analytics → Settings.

Out of scope this phase (tracked, not stubbed): Admin module (P2), real Isar offline cache + sync (P3), barcode/voice/SMS OTP/GPS (P4), Excel/PDF/WhatsApp (P5), Super Admin (P6). Full phase ladder in [roadmap.md](./roadmap.md).

## Known stale docs (update before/with the next PR that touches them)

- `docs/decisions/0004-google-sheets-as-backend.md` — **superseded** by the Supabase decision (write a new ADR `0006-supabase-as-backend.md` superseding 0004).
- `docs/decisions/0005-design-system.md` — font flip from Inter → Plus Jakarta Sans needs an addendum.
- `docs/architecture.md` — references Hive + Sheets; should reference Isar + Supabase.
- `docs/design-system.md` — Inter → Plus Jakarta Sans; document the new tint tokens (`blueLight`, `blueMid`, `greenLight`, `orangeLight`, `redLight`).

## Design source

Canonical design: the Claude Design handoff bundle (`DistroLink Wireframes.html`) — re-fetch via the design URL the user shared. The user iterated to: brand palette (`#2563EB` blue, `#10B981` green, `#0F172A` dark navy), Plus Jakarta Sans, full business-model alignment with the schema in [database.md](./database.md). Don't redesign without checking back.
