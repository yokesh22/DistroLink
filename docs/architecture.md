# Architecture

## Top-down view

```
lib/
  main.dart           entrypoint; runs bootstrap then runApp
  bootstrap.dart      framework init (Hive, logger, error handlers — added as needed)
  app/                MaterialApp root, router, theme
  core/               cross-cutting code (config, errors, network, storage, utils, widgets)
  features/           feature-first modules; each feature owns its own data/domain/presentation
    auth/             (placeholder) Google sign-in flow when added
    shops/            shop selection (manual + GPS)
    catalog/          product catalogue
    orders/           order entry form, history, line items
    sync/             offline outbox processor + status UI
  services/           thin wrappers around platform/external clients
    sheets/           Google Sheets API client wrapper
    location/         geolocator wrapper
    connectivity/     connectivity_plus wrapper
  l10n/               ARB translation files (added when i18n is needed)
```

## Rules

1. **Features never import each other.** Cross-feature concerns live in `core/` or `services/`.
2. **`data/`, `domain/`, `presentation/` subfolders inside a feature are added only when the feature outgrows a flat layout.** No empty ceremony folders.
3. **`services/` wraps third-party clients** so the rest of the app talks to a stable internal interface (easier to mock, swap, or instrument).
4. **State management is Riverpod.** No `setState` in production widgets except for ephemeral UI state (controllers, animations).

## Data flow (target)

```
UI → Riverpod controller → Repository → (Local Hive cache | Sheets API)
                                     ↓
                              Offline outbox (Hive box)
                                     ↓
                          Sync service drains outbox when online
```

The offline-first design is **TODO** — wired up once order capture and sheets writes land.

## Open architectural questions

- Auth model (per-user Google sign-in vs shared service account) — see [ADR-0004](decisions/0004-google-sheets-as-backend.md)
- Sheets schema ownership (one master sheet vs sheet-per-distributor) — TBD
- Catalog source (hardcoded, sheet-driven, or remote API) — TBD
