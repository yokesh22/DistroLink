# ADR 0005 — Design system as code (tokens + themed widgets)

**Status:** Accepted (2026-05-01)

## Context

The design system spec covers colours, typography, spacing, components, dark mode, and UX principles. We need a way to apply it consistently across every screen without each developer (or future-Claude) eyeballing hex values.

## Decision

Encode the design system as Dart tokens + a fully themed `ThemeData`:

- **Tokens** in `lib/core/theme/`:
  - `app_colors.dart` — every brand, status, and neutral colour
  - `app_spacing.dart` — 8px scale + radii
  - `app_typography.dart` — Inter-based `TextTheme` builder + numeric style
- **`ThemeData`** in `lib/app/theme.dart` builds light + dark from those tokens, including component themes (buttons, inputs, cards, lists, snackbars). Plain Material widgets pick up the look automatically.
- **Opinionated wrappers** in `lib/core/widgets/` (`AppButton`, `AppCard`, `AppTextField`) bake in the design-system rules that aren't expressible in `ThemeData` (label above input, default-full-width buttons, default card padding).
- **Inter font** via `google_fonts` package.
- **Dark mode** wired via `darkTheme:` on `MaterialApp`; `ThemeMode.system` is the default.

## Consequences

- A change to a colour or spacing value is one edit, applied everywhere.
- New screens get the design system "for free" — no per-screen styling needed.
- `google_fonts` fetches Inter at runtime by default. For an offline-first field app this is **a known gap**: the first launch on a no-connectivity device will fall back to system-ui until the font cache populates. Fix by bundling Inter TTFs in `assets/fonts/` and configuring `GoogleFonts.config.allowRuntimeFetching = false`. Tracked in [setup.md](../setup.md).
- Design-system changes are now an ADR + doc + code change — slightly more friction than ad-hoc styling, deliberately so.
