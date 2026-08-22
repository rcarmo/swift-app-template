# Native visual system

## Color and appearance

Use SwiftUI semantic colors (`primary`, `secondary`, `tint`) and system materials. Light and dark modes are distinct contexts; semantic APIs adapt them better than manually inverted palettes. If brand colors are necessary, define named asset variants and verify contrast in both appearances and increased contrast.

Do not use color as the only status cue. Avoid accent color over large passive regions. Prefer hierarchy through spacing, typography, grouping, and system backgrounds over stacks of borders and shadows.

## Typography

- Use semantic text styles (`body`, `headline`, `title`, etc.) so Dynamic Type and platform metrics work.
- Use `bold()` for contextual bold; reserve explicit weights for deliberate hierarchy.
- De-emphasize with hierarchical foreground styles rather than artificially light font weights.
- Use monospaced digits for changing or column-aligned numbers.
- Keep long-form text near a readable measure and use enough line spacing.
- Avoid tiny captions for essential content.

A design-system enum may hold repeated semantic roles and metrics, but should not freeze every Apple control to a custom number. Add a token after a relationship repeats and has a name.

## Materials and depth

Use native materials for sidebars, toolbars, popovers, ornaments, and transient chrome only where system behavior expects them. Keep reading/body surfaces sufficiently opaque. Let windows, sheets, menus, and popovers supply native corner radius and shadow. Do not layer custom shadows to imitate macOS when the platform already renders the surface.

## Symbols and imagery

Use SF Symbols with text labels for actions. Choose rendering mode and variable value intentionally. Decorative imagery is hidden from accessibility; meaningful imagery has an equivalent description. Generated asset symbols are preferred when enabled.

## Spacing and controls

System controls determine much of their platform-specific sizing. Use semantic padding/spacing around them instead of forcing iOS and macOS to share pixel dimensions. Touch targets remain at least 44 points; a smaller macOS visual control still needs clear keyboard/focus behavior.

## Review appearances

Check light, dark, increased contrast, Reduce Transparency, system tint/accent changes, active/inactive macOS windows, disabled state, keyboard focus, hover, selection, and tvOS focus. A screenshot in one appearance is not approval.
