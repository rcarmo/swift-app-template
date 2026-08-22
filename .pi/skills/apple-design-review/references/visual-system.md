# Native visual system

## Colour and appearance

Use SwiftUI semantic colours (`primary`, `secondary`, `tint`) and system materials. Treat light and dark appearances as separate review conditions. Define named light, dark, and increased-contrast variants when a product colour is necessary.

Do not use colour as the only status cue. Avoid accent colour over large passive regions. Establish hierarchy through spacing, typography, grouping, and system backgrounds before adding borders or shadows.

## Typography

Follow `../../apple-typography/SKILL.md`. Use semantic text styles, monospaced digits for changing or aligned numbers, readable line measure, and enough line spacing. Avoid small captions for essential content.

A design-system enum may hold repeated semantic roles and metrics. Add a token after a relationship repeats and has a stable name; do not freeze system controls to custom dimensions.

## Materials and depth

Use native materials where macOS uses them: sidebars, toolbars, popovers, and transient chrome. Keep reading surfaces sufficiently opaque. Let windows, sheets, menus, and popovers provide their system corner radius and shadow.

## Symbols and imagery

Use SF Symbols with text labels for actions. Choose rendering mode and variable value deliberately. Hide decorative imagery from accessibility and describe meaningful imagery. Use generated asset accessors only when the package or application target enables them; otherwise centralise typed asset references.

## Spacing and controls

System controls determine much of their size. Add semantic padding and spacing around them instead of overriding intrinsic metrics. Controls must remain easy to acquire with a pointer and fully usable with keyboard focus.

## Appearance review

Check light and dark appearance, Increase Contrast, Reduce Transparency, system tint, active and inactive windows, disabled state, keyboard focus, hover, selection, drag-destination state, and error state. Capture more than one appearance before approving visual work.
