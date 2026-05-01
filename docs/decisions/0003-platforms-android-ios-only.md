# ADR 0003 — Android + iOS only

**Status:** Accepted (2026-05-01)

## Context

`flutter create` scaffolds six platforms: Android, iOS, web, macOS, Linux, Windows. Each adds maintenance surface (CI build matrices, native plugin compatibility, platform-specific bugs).

DistroLink's users are field distributors using mobile devices.

## Decision

Ship **Android (min API 26 / Android 8) and iOS** only. The `web/`, `macos/`, `linux/`, `windows/` folders have been deleted from the repo, and corresponding entries removed from `.metadata`.

## Consequences

- Smaller surface; fewer plugin compatibility surprises.
- If a desktop or web variant is ever needed, run `flutter create --platforms=web .` from the project root to re-add it.
- Some plugins that exist only on web/desktop won't be considered (acceptable — none are needed today).
