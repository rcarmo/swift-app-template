# Typography system

## Semantic scale

Start with system styles: `.largeTitle`, `.title`, `.title2`, `.title3`, `.headline`, `.body`, `.callout`, `.subheadline`, `.footnote`, and `.caption`. Select by semantic role, not by visual trial-and-error. Store repeated roles in a design-system namespace only when that makes hierarchy more consistent.

Example role mapping:

| Role | Typical semantic style |
|---|---|
| screen/page title | `.largeTitle` or platform navigation title |
| major section | `.title2` / `.headline` depending context |
| lead/standfirst | `.title3` or `.body` with secondary style |
| body | `.body` |
| control label | system control default / `.body` |
| metadata | `.subheadline`, `.footnote`, or sparing `.caption` |
| code | `.body.monospaced()` |
| table number | `.body.monospacedDigit()` |

This is not a fixed prescription; system containers often choose the right style automatically.

## Hierarchy

Use no more levels than the content structure requires. Weight signals emphasis, while `secondary`/`tertiary` styles signal de-emphasis. Do not create hierarchy with many near-identical sizes or opacity values. Keep headings close to the content they introduce and add more space before a new section than within one.

## Readability

Long-form body lines should remain near a comfortable reading measure (roughly 60–75 characters in many Latin scripts), but validate other scripts rather than enforcing character counts globally. Allow adequate line spacing and paragraph separation. Avoid all-caps for long labels and never assume English word lengths.

## Dynamic Type and platform behavior

Test accessibility sizes, Bold Text, and increased contrast. Use `@ScaledMetric` for custom dimensions that must follow text. tvOS text must read at distance; watchOS needs concise hierarchy; macOS can be denser but still needs legibility and accessibility scaling.

## Truncation

Wrap essential text. Truncate only when the full value remains available through detail, tooltip, accessibility label/value, or another discoverable route. Use tail truncation for ordinary titles. Tables need column priorities and resizing behavior, not indiscriminate one-line clipping.

## Custom fonts

Confirm redistribution licence, variable/static files, supported weights, glyph/language coverage, fallback behavior, bundle inclusion, and launch/rendering cost. Register through Xcode resources and use `relativeTo:` or other Dynamic Type-aware scaling. System typography is the default.
