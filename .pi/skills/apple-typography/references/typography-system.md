# Typography system

## Semantic scale

Start with `.largeTitle`, `.title`, `.title2`, `.title3`, `.headline`, `.body`, `.callout`, `.subheadline`, `.footnote`, and `.caption`. Select a style by semantic role. Store repeated roles in the design-system namespace only when that improves consistency.

| Role | Typical style |
|---|---|
| window or page title | system navigation title or `.largeTitle` |
| major section | `.title2` or `.headline`, according to context |
| lead text | `.title3` or `.body` with a secondary style |
| body | `.body` |
| control label | system control default or `.body` |
| metadata | `.subheadline`, `.footnote`, or sparing `.caption` |
| code | `.body.monospaced()` |
| table number | `.body.monospacedDigit()` |

System containers often choose the correct style without an override.

## Hierarchy

Use no more levels than the content structure needs. Weight signals emphasis; `secondary` and `tertiary` foreground styles signal de-emphasis. Avoid many near-identical sizes or opacity values. Keep headings with the content they introduce and put more space before a new section than within it.

## Readability

Keep long Latin-script body lines near 60–75 characters where practical, but test each supported script instead of enforcing one character count. Use adequate line spacing and paragraph separation. Avoid all caps for long labels and do not assume English word lengths.

## Text scaling and dense views

Test the supported macOS text and accessibility settings, Bold Text where available, and Increase Contrast. Use `@ScaledMetric` for custom dimensions that must follow a text style. Check sidebars, tables, inspectors, forms, and narrow windows; density does not justify clipped or unreadable text.

## Truncation

Wrap essential text. Truncate only when the full value remains available through detail, a tooltip, an accessibility value, or another discoverable route. Use tail truncation for ordinary titles. Tables need column priorities and resize behaviour, not universal one-line clipping.

## Custom fonts

Confirm the redistribution licence, files and weights, glyph coverage, fallbacks, bundle inclusion, and launch/rendering cost. Include fonts through SwiftPM resources or application-bundle resources and scale them relative to semantic text styles. System typography is the default.
