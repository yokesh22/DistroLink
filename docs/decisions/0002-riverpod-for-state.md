# ADR 0002 — Riverpod for state management

**Status:** Accepted (2026-05-01)

## Context

State management options considered: Provider, Riverpod, Bloc, GetX.

DistroLink will be async-heavy (Sheets API calls, offline outbox sync, GPS) and needs robust DI for testing. The developer has no strong prior preference.

## Decision

Use **Riverpod 3.x** (`flutter_riverpod` + `riverpod_annotation` + `riverpod_generator`).

## Consequences

- Compile-time safe DI; no `BuildContext`-based provider lookups.
- First-class `AsyncValue` ergonomics for the network/sheets work that dominates this app.
- Codegen friction (must run `build_runner` watcher during dev). Worth it for the safety.
- `riverpod_lint` is currently incompatible with our other dep versions, so we ship without those lint rules until the ecosystem catches up. Recorded in [setup.md](../setup.md).
