---
name: apple-typography
description: Design or review semantic typography, readable measure, hierarchy, emphasis, numeric alignment, Dynamic Type, and cross-platform text behavior in SwiftUI.
license: MIT
metadata:
  version: "1.0"
  provenance: Independently adapted from typography concerns in tqbf/swiftui-app, ceorkm/macos-design-skill, and twostraws design guidance; see NOTICE.md.
---

# Apple typography

Read `references/typography-system.md`. Use whenever creating a design system, adding custom fonts, changing text hierarchy, building dense macOS tables, or reviewing readability and Dynamic Type.

## Workflow

1. Inventory semantic roles: page title, section heading, body, lead, label, metadata, code, and numbers.
2. Map roles to SwiftUI text styles before considering custom point sizes.
3. Establish hierarchy with style, weight, spacing, and foreground hierarchy—not many arbitrary sizes.
4. Cap long-form measure and test wrapping, truncation, localization expansion, and accessibility sizes.
5. Use monospaced digits for changing/column-aligned numbers and monospaced design only for code/technical data.
6. Validate each target platform; macOS density does not justify unreadable type, and iOS sizes should not be copied mechanically to watchOS/tvOS.

## Guardrails

- No hard-coded point size without Dynamic Type scaling and a documented visual requirement.
- No essential content in `.caption2`; use `.caption` sparingly.
- Prefer `bold()` for contextual bold; explicit weight belongs to a named hierarchy role.
- De-emphasize with semantic foreground styles rather than thin font weights or low opacity.
- Avoid fixed-height frames around text.
- Do not ship a custom font without licence, fallback, localization glyph coverage, and accessibility review.

## Output

Provide a role-to-style table, affected platforms, line-length/wrapping behavior, Dynamic Type results, and any custom-font licensing/fallback concerns.
