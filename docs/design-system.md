# Design System

This document is the source of truth for DistroLink's visual language. Code references are in `lib/core/theme/` and `lib/core/widgets/`. **If you need a colour, spacing value, or text style — use a token, never a literal.**

> Brand feel: clean, modern, mobile-first SaaS. Stripe / Google Pay simplicity. Professional, not flashy.

---

## 🎨 Colors

Defined in [lib/core/theme/app_colors.dart](../lib/core/theme/app_colors.dart).

### Brand
| Token | Hex | Use |
|---|---|---|
| `AppColors.primary` | `#2563EB` | Primary buttons, active states, links |
| `AppColors.accent` | `#10B981` | **Success / totals / completed only** — never as a primary action colour |

### Status
| Token | Hex | Use |
|---|---|---|
| `AppColors.success` | `#22C55E` | Success banners, confirmation icons |
| `AppColors.warning` | `#F59E0B` | Caution states, soft errors |
| `AppColors.error` | `#EF4444` | Validation errors, destructive actions |

### Neutrals (Light)
| Token | Hex |
|---|---|
| `lightBackground` | `#FFFFFF` |
| `lightSurface` (cards) | `#F8FAFC` |
| `lightBorder` | `#E2E8F0` |
| `lightTextPrimary` | `#0F172A` |
| `lightTextSecondary` | `#64748B` |

### Neutrals (Dark)
| Token | Hex |
|---|---|
| `darkBackground` | `#0F172A` (never pure black) |
| `darkSurface` | `#1E293B` |
| `darkBorder` | `#334155` |
| `darkTextPrimary` | `#F1F5F9` |
| `darkTextSecondary` | `#94A3B8` |

### Rules
- **Blue is the only colour for primary actions.**
- **Green is reserved for success / totals / completed states** — do not reach for it as a generic accent.
- Avoid using more than ~3 colours on a single screen (brand + neutral + one status).

---

## 🔤 Typography

Defined in [lib/core/theme/app_typography.dart](../lib/core/theme/app_typography.dart). Inter via `google_fonts`, with `system-ui, sans-serif` as the platform fallback.

| Role | Flutter style | Size | Weight |
|---|---|---|---|
| Heading L | `headlineLarge` | 24 | 600 |
| Heading M | `headlineMedium` | 22 | 600 |
| Heading S | `headlineSmall` | 20 | 600 |
| Subheading L | `titleLarge` | 18 | 500 |
| Subheading M | `titleMedium` | 16 | 500 |
| Body L | `bodyLarge` | 16 | 400 |
| Body M | `bodyMedium` | 14 | 400 |
| Small | `bodySmall` | 12 | 400 |
| Button | `labelLarge` | 14 | 500 |

For **prices, quantities, totals** use `AppTypography.numeric(...)` — Inter with tabular figures and 600 weight, so columns of numbers align cleanly.

### Rules
- Readability beats style. Don't shrink body text below 14px.
- Numbers should feel slightly heavier than surrounding prose.

---

## 📐 Layout & Spacing

Defined in [lib/core/theme/app_spacing.dart](../lib/core/theme/app_spacing.dart).

| Token | Value | Use |
|---|---|---|
| `AppSpacing.xs` | 8 | Tight gaps, icon padding |
| `AppSpacing.sm` | 16 | Default gap, card padding, screen edges |
| `AppSpacing.md` | 24 | Section separation |
| `AppSpacing.lg` | 32 | Major section breaks |
| `AppSpacing.screenPadding` | 16 | Padding around screen content |
| `AppSpacing.radiusInput` | 8 | Inputs, buttons |
| `AppSpacing.radiusButton` | 8 | Inputs, buttons |
| `AppSpacing.radiusCard` | 12 | Cards |

**Rule:** never hard-code a spacing or radius literal — extend the token set if you need a new one.

---

## 🧱 Components

All in [lib/core/widgets/](../lib/core/widgets/). The Material `ThemeData` in [lib/app/theme.dart](../lib/app/theme.dart) styles built-in widgets too — so a plain `ElevatedButton` already looks correct. Reach for the `App*` wrappers for opinionated shortcuts (full-width default, label-above-input, padded card).

### `AppButton`
- Primary: blue fill, white text. For the main action on a screen.
- Secondary: outlined. For "Cancel", "Back", or alternate actions.
- **Defaults to `fullWidth: true`** because the design system says important actions should be full width. Pass `fullWidth: false` for inline use.
- Supports `loading: true` and an optional leading `icon`.
- Min height 48 — large touch target for field use.

### `AppCard`
- 12px corners, 1px border, very subtle shadow.
- Default padding `AppSpacing.sm` (16). Override via `padding:` if needed.
- Pass `onTap` to make it an inkwell.

### `AppTextField`
- Label rendered **above** the field (not as a placeholder).
- Use `hint:` for the in-field placeholder.
- Surface-coloured fill, 8px corners.
- 1.5px focused border in primary blue.

---

## 🌙 Dark Mode

`MaterialApp` is wired with both `theme:` and `darkTheme:` and follows the system preference (`ThemeMode.system` is the Material default). All tokens have light + dark counterparts — components automatically pick up the right palette.

- Dark background is **`#0F172A`**, not pure black, to reduce OLED smear and improve long-session readability.
- Borders in dark mode are `#334155` — visible but soft.

---

## ⚡ UX Principles

These are not visual — they shape every screen we build:

1. **Fast data entry first.** Distributors are entering orders in shops with limited time. Forms must minimise typing — prefer dropdowns, autocomplete, and recent-values shortcuts.
2. **Large touch targets.** 48dp minimum for primary actions. Buttons enforce this through theme.
3. **Step-based flows.** Order creation should be a sequence of small steps, not one massive form.
4. **Avoid clutter.** One screen, one job. Hide secondary actions behind menus.
5. **Designed for low-end Android.** Avoid heavy animations, large images, or runtime-fetched assets that could stall on slow devices or flaky networks.

---

## 📊 Data Display

- **Totals stand out** — use `AppTypography.numeric(color: AppColors.accent)` or bold + accent.
- **Cards for analytics blocks** (orders count, revenue, etc.) — use `AppCard`.
- **Charts:** stick to bar and line. No pies, no doughnuts, no 3D.

---

## Adding to the system

Adding a token, component, or rule is a deliberate act:

1. Update this document first.
2. Add the token to the appropriate `lib/core/theme/` file or component to `lib/core/widgets/`.
3. Note the addition in [decisions/0005-design-system.md](decisions/0005-design-system.md) if it materially changes the system.
