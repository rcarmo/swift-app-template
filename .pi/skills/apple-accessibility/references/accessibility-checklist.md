# Accessibility checklist

## Semantics

- Every control has a useful name matching visible language.
- Dynamic labels keep a stable Voice Control input label when changing values would make commands unpredictable.
- Group composite rows when separate children create noise; expose separate actions when users need them.
- Mark headings so rotor navigation reflects content hierarchy.
- Add accessibility values for sliders, progress, status, and custom controls.
- Decorative images and repeated icons are hidden; informative images have labels or descriptions.
- Charts and visualizations provide summaries and inspectable values or an equivalent table.

## Text and layout

- Use semantic text styles.
- Test the largest accessibility Dynamic Type categories.
- Text wraps rather than clips; essential controls remain reachable.
- Avoid `.caption2`; use `.caption` sparingly.
- Do not use fixed-height containers around variable text.
- Minimum touch target is 44 by 44 points even if the visual glyph is smaller.

## Color and appearance

- Contrast remains sufficient in light/dark and increased-contrast modes.
- Selection/status/error is not communicated by color alone; add shape, icon, text, or pattern.
- Respect `.accessibilityDifferentiateWithoutColor`.
- Use semantic system colors/materials rather than opacity hacks.
- Test Reduce Transparency if material is important to legibility.

## Motion

Read `accessibilityReduceMotion`. Replace large movement, parallax, zoom, or repeated motion with a restrained opacity/state change. Never require an animation to understand completion.

## Input and focus

- Full Keyboard Access reaches every action in a logical order.
- Focus does not become trapped or disappear after modal dismissal/deletion.
- tvOS focus has visible state and predictable movement.
- watchOS actions are concise and reachable while scrolling/crown input is active.
- Drag-and-drop has an alternate button/menu/import/export path.
- Hover-only affordances have keyboard and accessibility alternatives.

## Manual run

Test at least one real or simulated run with VoiceOver, Voice Control naming, largest text, Reduce Motion, Differentiate Without Color, increased contrast, and keyboard/focus. Accessibility identifiers are for UI testing; they do not replace user-facing labels.
