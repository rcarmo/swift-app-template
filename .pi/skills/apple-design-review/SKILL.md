---
name: apple-design-review
description: Design or review native SwiftUI interfaces across iOS, iPadOS, macOS, Mac Catalyst, tvOS, visionOS, and watchOS, including layout, visual hierarchy, interaction, input, and platform adaptation.
license: MIT
metadata:
  version: "2.0"
  provenance: Adapted from ceorkm/macos-design-skill, twostraws design guidance, and project-specific cross-Apple rules; see NOTICE.md.
---

# Apple-platform design review

This is the visual and interaction entry point. Read `docs/DESIGN.md` and the references relevant to the task:

- `references/layout-and-composition.md`
- `references/visual-system.md`
- `references/interaction-patterns.md`
- `references/platform-matrix.md`

Load `../apple-accessibility/SKILL.md` for the accessibility gate and `../swiftui-navigation/SKILL.md` for navigation/presentation changes.

## Design workflow

1. Name the primary user task and content hierarchy.
2. Choose system window/scene, navigation, toolbar, list/table/grid, form, and presentation patterns.
3. Sketch every state: loading, populated, empty, search-empty, failure, permission denied, offline, selection absent.
4. Define actions across touch, pointer, keyboard, remote/focus, crown, voice, and drag/drop as applicable.
5. Use semantic system typography, color, materials, symbols, spacing, and controls first.
6. Adapt composition at platform seams; do not scale one screenshot to every device.
7. Review light/dark, resizing, localization expansion, Dynamic Type, contrast, and reduced motion.
8. Run previews/screenshots for representative states, then validate live behavior on the lowest supported OS/device class.

## Native-system rule

The audited macOS source also addresses web/Electron simulations. This repository is native SwiftUI: do not draw traffic lights, fake title bars, recreate materials with arbitrary RGBA values, or hard-code CSS-derived measurements. Let macOS own window chrome; use toolbar/titlebar/window APIs, semantic materials/colors, and controls.

## Output

Group findings into blockers, important improvements, and polish. Name the platform, window/size class, input method, and affected state. Prefer fewer clearer controls over ornamental chrome.
