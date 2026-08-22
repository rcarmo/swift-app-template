---
name: apple-design-review
description: Design or review native macOS SwiftUI interfaces, including layout, visual hierarchy, interaction, keyboard and pointer input, windowing, and system integration.
license: MIT
metadata:
  version: "3.0"
  provenance: Adapted from ceorkm/macos-design-skill, twostraws design guidance, and project-specific macOS rules; see NOTICE.md.
---

# macOS design review

Read `docs/DESIGN.md` and the references needed for the task:

- `references/layout-and-composition.md`
- `references/visual-system.md`
- `references/interaction-patterns.md`
- `references/platform-matrix.md`

Run the accessibility gate in `../apple-accessibility/SKILL.md`. Load `../swiftui-navigation/SKILL.md` for navigation or presentation changes.

## Workflow

1. Name the primary user task and content hierarchy.
2. Choose system windows, scenes, navigation, toolbars, lists, tables, grids, forms, and presentation containers.
3. Cover loading, populated, empty, search-empty, failure, permission-denied, offline, and absent-selection states.
4. Define pointer, keyboard, VoiceOver, Voice Control, menu/command, drag-and-drop, and multi-window behaviour where applicable.
5. Start with semantic system typography, colour, materials, symbols, spacing, and controls.
6. Review narrow, standard, wide, full-screen, active, and inactive window states.
7. Check light and dark appearance, localisation expansion, text scaling, contrast, Reduce Transparency, and Reduce Motion.
8. Use previews for representative states, then run the assembled app on the lowest supported macOS version and representative hardware/input devices.

## Native composition

This repository uses native SwiftUI for macOS. Use system title-bar, toolbar, window, material, colour, and control APIs. Do not draw traffic lights, fake title bars, copy browser or Electron chrome, or convert CSS measurements into fixed SwiftUI metrics.

## Output

Group findings into blockers, important improvements, and polish. Name the macOS version, window size/state, input method, and affected application state. Give the consequence and smallest correction for each finding.
