---
name: apple-localization
description: Add or review macOS user-facing strings, String Catalogs, plurals, formatting, bidirectional layout, locale-sensitive search, and localisation tests.
license: MIT
metadata:
  version: "2.0"
  provenance: Adapted from twostraws hygiene/API guidance and project-specific Apple localisation practice; see NOTICE.md.
---

# macOS localisation

Read `references/localization-checklist.md` when adding user-visible text, dates, numbers, units, names, search, layout direction, screenshots, or release-facing copy.

The starter currently has no String Catalog and uses inline English strings. Introduce a catalog deliberately when the derived product adopts localisation; do not claim generated string symbols are enabled unless package/resource configuration proves it.

## Workflow

1. Inventory user-facing strings, including errors, accessibility labels, menus, commands, tooltips, empty states, and permission explanations.
2. Add stable catalog keys and translator context if the product has adopted a String Catalog.
3. Keep interpolation and plural variants in one localisable unit; do not concatenate translated fragments.
4. Use `FormatStyle` for dates, numbers, currency, measurements, and person names.
5. Test long translations, right-to-left layout, non-Latin input, locale-specific calendars/numbers, and macOS text scaling.
6. Keep logs, identifiers, protocol payloads, file formats, and developer diagnostics separate from localised UI.

## Guardrails

- Do not assemble user-facing text with `+`.
- Do not hand-code singular/plural branches when catalog variation applies.
- Do not use `String(format:)` for display formatting.
- Do not impose fixed widths because the English text fits.
- Use `localizedStandardContains` for ordinary local user search unless domain semantics require exact matching.
- Do not localise stable data keys, URLs, notification names, or analytics identifiers.

## Output

List catalog keys and locales affected, formatting APIs, windows/states reviewed, and strings deliberately left unlocalised with reasons. State whether a catalog and generated accessors actually exist.
