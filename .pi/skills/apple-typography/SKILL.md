---
name: apple-typography
description: Design or review semantic typography, readable measure, hierarchy, emphasis, numeric alignment, text scaling, and macOS text behaviour in SwiftUI.
license: MIT
metadata:
  version: "2.0"
  provenance: Independently adapted from typography concerns in tqbf/swiftui-app, ceorkm/macos-design-skill, and twostraws design guidance; see NOTICE.md.
---

# macOS typography

Read `references/typography-system.md` when creating a design system, adding custom fonts, changing text hierarchy, building dense tables, or reviewing readability and text scaling.

## Workflow

1. Inventory semantic roles: window title, section heading, body, lead, label, metadata, code, and numbers.
2. Map roles to SwiftUI text styles before considering custom point sizes.
3. Establish hierarchy with style, weight, spacing, and foreground hierarchy.
4. Cap long-form measure and test wrapping, truncation, localisation expansion, and accessibility settings.
5. Use monospaced digits for changing or column-aligned numbers; reserve monospaced text for code and technical data.
6. Test supported macOS versions, narrow and wide windows, dense data views, and the largest supported text settings.

## Guardrails

- Do not hard-code a point size without text-style-relative scaling and a documented requirement.
- Do not put essential content in `.caption2`; use `.caption` sparingly.
- Use `bold()` for contextual emphasis. Give explicit weights a named hierarchy role.
- De-emphasise with semantic foreground styles instead of thin weights or low opacity.
- Avoid fixed-height frames around text.
- Do not ship a custom font without a redistribution licence, fallback, localisation glyph coverage, and accessibility review.

## Output

Provide a role-to-style table, affected windows and views, wrapping/truncation behaviour, text-scaling results, and custom-font licence or fallback concerns.
