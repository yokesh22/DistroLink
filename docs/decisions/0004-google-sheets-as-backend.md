# ADR 0004 — Google Sheets as the order backend

**Status:** Proposed (2026-05-01) — auth model still open

## Context

Orders captured in the field need to land somewhere downstream operations can read. Stakeholder requirement: a Google Sheet, not a custom backend.

## Decision

Use Google Sheets as the system of record for order entries. The app appends rows to the sheet via the Sheets v4 API.

Auth model is **not yet decided**. Two candidates:

1. **Per-distributor Google sign-in** (`google_sign_in` + `extension_google_sign_in_as_googleapis_auth`). Each distributor's writes appear under their own identity in sheet revision history. Audit-friendly. Requires onboarding (sharing the sheet with each distributor's Google account).
2. **Shared service account JSON shipped in the app.** Single robot identity. Simpler onboarding but anyone who decompiles the APK extracts the credentials — high risk.

Auth packages are intentionally **not** installed yet — see [setup.md](../setup.md).

## Consequences

- Sheets quota: 300 read requests/min/project, 60 writes/min/user. Should be plenty for field use; monitor as user count grows.
- Schema lives in the sheet (column headers). Schema changes require coordination with whoever owns the sheet.
- Offline support is mandatory: distributors will be in low-connectivity locations. Outbox in Hive, drained by the sync feature when online.

## Status

Auth model decision and sheet schema are blocked on full requirements from the user. Update this ADR (and flip status to Accepted) once decided.
