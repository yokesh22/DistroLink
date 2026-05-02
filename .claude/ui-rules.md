# UI Rules

Full visual spec lives in [`docs/design-system.md`](../docs/design-system.md). This file is the operational shortlist — what to do, what not to do, and what wrappers to reach for.

## Design intent

- **Brand feel:** clean, modern, mobile-first SaaS. Stripe / Google Pay simplicity. Professional, not flashy.
- **Audience:** salesmen using the app one-handed in a busy shop on a low-end Android. Touch targets, contrast, and speed matter more than animation.

## Tokens — never literals

Always use these. Extend the token set if you need a new value.

- **Colors:** [`lib/core/theme/app_colors.dart`](../lib/core/theme/app_colors.dart) — `AppColors.primary` (#2563EB blue), `AppColors.accent` (#10B981 green — totals/success only), `AppColors.warning` (#F59E0B), `AppColors.error` (#EF4444), and the light/dark neutrals (`lightBackground`, `lightSurface`, `lightBorder`, `lightTextPrimary`, `lightTextSecondary` + dark counterparts).
- **Spacing & radii:** [`lib/core/theme/app_spacing.dart`](../lib/core/theme/app_spacing.dart) — `AppSpacing.xs` (8) / `sm` (16) / `md` (24) / `lg` (32) and `radiusInput` / `radiusButton` (8) / `radiusCard` (12).
- **Typography:** [`lib/core/theme/app_typography.dart`](../lib/core/theme/app_typography.dart) — **Plus Jakarta Sans** via `google_fonts`. Use the `TextTheme` (`titleLarge`, `bodyMedium`, etc.) — don't construct `TextStyle` from scratch. For prices/quantities/totals use `AppTypography.numeric(...)` (tabular figures, weight 600).

## Color rules

- **Blue** is the only color for primary actions.
- **Green** is reserved for success / totals / completed states. Never as a generic accent.
- **Orange** (`warning`) for offline / pending sync / soft errors only.
- **Red** (`error`) for destructive actions and validation errors only.
- Avoid more than ~3 colors on a single screen (brand + neutral + one status).

## Wrappers (always prefer over raw widgets)

In [`lib/core/widgets/`](../lib/core/widgets/):

- **`AppButton`** — primary (filled blue) and `secondary` (outlined). Defaults to `fullWidth: true` because important actions should be full width; pass `fullWidth: false` for inline. Min height 48dp. Supports `loading: true` and an optional leading `icon`.
- **`AppCard`** — 12dp corners, 1dp border, subtle shadow. Default padding `AppSpacing.sm` (16). Pass `onTap` to make it inkwell-tappable.
- **`AppTextField`** — label rendered **above** the field (not as placeholder). Use `hint:` for in-field placeholder. Surface fill, 8dp corners, 1.5dp focused border in primary blue.

To add (Phase 1, per the wireframe):
- **`AppSegmented`** — segmented control (OTP/Password toggle, Order Type Regular/Urgent/Credit).
- **`AppChip`** — pill chip with `active` variant (Quick Add, filter chips).
- **`AppStepIndicator`** — 4-dot stepper with done/active/pending states.
- **`AppQtyStepper`** — `+/−` stepper with 40dp targets, min `1`.
- **`AppOfflineBanner`** — orange offline bar.
- **`AppStatCard`** — label + big-number + footnote tile (composes `AppCard`).

For built-in widgets — `ElevatedButton`, `OutlinedButton`, `Card`, `TextField`, `ListTile`, `Divider`, `SnackBar`, `AppBar` — the `ThemeData` in [`lib/app/theme.dart`](../lib/app/theme.dart) already styles them. They look correct without per-widget tweaks. **Reach for the `App*` wrapper only when you need its opinionated default** (full-width, label-above, padded card, etc.).

## Layout

- Default screen padding: `AppSpacing.screenPadding` (16).
- Default vertical gap between major sections: `AppSpacing.md` (24).
- Default vertical gap inside a card: `AppSpacing.xs` (8) for tight, `sm` (16) for default.
- Bottom nav for the salesman shell: 4 tabs — Home / Orders / Stats / Settings. Active tab = primary blue; inactive = `textSecondary`.
- FAB on Home / Orders for "+ New Order".

## Dark mode

`MaterialApp` is wired with both `theme:` and `darkTheme:`. Default = `ThemeMode.system`. Settings exposes a manual toggle (persisted in `themeModeProvider`).

- Dark background is **`#0F172A`** (never pure black) — reduces OLED smear.
- Borders in dark mode are `#334155` — visible but soft.
- All tokens have light + dark counterparts; widgets pick up the right palette automatically.

## UX principles (always apply)

1. **Fast data entry first** — minimise typing. Prefer dropdowns, autocomplete, recent-values, segmented controls, +/− steppers.
2. **Large touch targets** — 48dp min for primary actions; 40dp min for secondary tappables (qty stepper buttons).
3. **Step-based flows** — break long forms (like order creation) into 3-5 steps with a visible step indicator.
4. **One screen, one job** — hide secondary actions behind menus.
5. **Designed for low-end Android** — avoid heavy animations, large images, runtime asset fetches (Inter is fetched at runtime by `google_fonts`; bundle Plus Jakarta Sans TTFs in `assets/fonts/` once before release — see [docs/decisions/0005-design-system.md](../docs/decisions/0005-design-system.md)).
6. **Numbers stand out** — use `AppTypography.numeric(...)`. Totals use weight 600 + `AppColors.accent` (green) for emphasis.
7. **Charts:** bar and line only. No pies, no doughnuts, no 3D. Prefer `CustomPaint` over heavy chart libs.

## Never-do list

- ❌ Hard-coded colors, spacing, or text styles.
- ❌ Green as a generic accent (it's reserved for totals/success).
- ❌ Body text below 14px.
- ❌ Pure black (`#000`) in dark mode.
- ❌ More than 3 status colors on one screen.
- ❌ Custom button shapes / corners — use `AppButton` or theme-styled built-ins.
- ❌ `TextStyle(fontSize: ..., fontWeight: ...)` from scratch — use the `TextTheme` or `AppTypography.numeric`.
- ❌ Snackbars with custom styling — the theme provides them.

## Adding to the design system

Adding a token, component, or rule is a **deliberate act**:

1. Update `docs/design-system.md` first.
2. Add the token to `lib/core/theme/...` or component to `lib/core/widgets/...`.
3. If it materially changes the system, write/update an ADR in `docs/decisions/`.
4. Update this `.claude/ui-rules.md` if the operational rule changes.
