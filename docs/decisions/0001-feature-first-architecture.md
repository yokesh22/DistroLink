# ADR 0001 — Feature-first architecture

**Status:** Accepted (2026-05-01)

## Context

Two mainstream approaches to organising a Flutter codebase:
- **Layer-first (clean architecture):** top-level `data/`, `domain/`, `presentation/` folders that each contain every feature.
- **Feature-first:** top-level `features/<name>/` folders that each contain their own (optional) data/domain/presentation split.

DistroLink starts as a small app maintained by a solo developer.

## Decision

Use **feature-first**. Layer subfolders (`data/`, `domain/`, `presentation/`) appear inside a feature only when that feature outgrows a flat layout.

Cross-cutting code lives in `lib/core/` (errors, network, storage, utils, shared widgets) and `lib/services/` (third-party client wrappers).

Features must not import each other directly — they share via `core/` or `services/`.

## Consequences

- Adding a feature = creating one folder; no need to touch four parallel layer folders.
- Refactors and deletions are localised — drop the whole feature folder.
- Risk: developers may smuggle cross-feature imports and bypass `core/`. Mitigated by code review (and later, an `import_lint` rule).
