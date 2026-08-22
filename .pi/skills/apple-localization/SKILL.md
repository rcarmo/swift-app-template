---
name: apple-localization
description: Add or review user-facing strings, String Catalogs, pluralization, formatting, bidirectional layout, locale-sensitive search, and localization tests.
license: MIT
metadata:
  version: "1.0"
  provenance: Adapted from twostraws hygiene/API guidance and project-specific Apple localization practice; see NOTICE.md.
---

# Apple localization

Read `references/localization-checklist.md`. Use whenever adding user-visible text, dates, numbers, units, names, search, layout direction, screenshots, or store-facing copy.

## Workflow

1. Inventory every new user-facing string, including errors, accessibility labels, menus, commands, empty states, and permission explanations.
2. Add symbol-keyed entries to a String Catalog with manual extraction state where the project uses generated symbols.
3. Use interpolation/plural variation in one localizable unit; do not concatenate translated fragments.
4. Use `FormatStyle` for dates, numbers, currency, measurement, and person names.
5. Test long translations, right-to-left layout, non-Latin input, locale-specific calendars/numbers, and accessibility text.
6. Keep logs, identifiers, protocol payloads, and developer diagnostics separate from localized UI.

## Guardrails

- No user-facing text assembled with `+`.
- No manual plural `count == 1` branching when catalog pluralization applies.
- No `String(format:)` for display formatting.
- No fixed-width layout justified only by English copy.
- User search uses `localizedStandardContains` unless domain semantics require exact matching.
- Do not localize stable data keys, URLs, notification names, or analytics identifiers.

## Output

List catalog keys/locales affected, formatting APIs, screenshots/states reviewed, and any strings deliberately not localized with reasons.
