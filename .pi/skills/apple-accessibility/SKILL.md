---
name: apple-accessibility
description: Implement or audit macOS SwiftUI accessibility across VoiceOver, Voice Control, keyboard navigation, Full Keyboard Access, text scaling, contrast, motion, focus, and pointer input.
license: MIT
metadata:
  version: "2.0"
  provenance: Adapted from twostraws accessibility guidance and macOS review practice; see NOTICE.md.
---

# macOS accessibility

Read `references/accessibility-checklist.md` for every user-interface feature, custom control, image, animation, chart, drag-and-drop interaction, or input workflow.

## Workflow

1. Define the label, value, hint, traits, actions, grouping, and heading level before visual styling.
2. Prefer native controls, which provide system behaviour and accessibility semantics.
3. Test flexible layout with the largest supported macOS text and accessibility settings.
4. Verify VoiceOver order, focus, actions, and announcements.
5. Verify that Voice Control uses visible, stable names.
6. Check light and dark appearance, Increase Contrast, Reduce Transparency, and Differentiate Without Color.
7. Check Reduce Motion for spatial or repeated animation.
8. Test keyboard navigation, Full Keyboard Access, pointer and hover, menu and toolbar access, drag-and-drop alternatives, and focus after state changes.
9. Record manual checks that cannot be automated.

## Guardrails

- An icon-only button still needs a text label. Use `Button("Label", systemImage: ...)` and apply `.labelStyle(.iconOnly)` only to the visual presentation.
- Hide decorative images. Give meaningful images concise labels or descriptions.
- Use `Button` for ordinary actions. Use gestures only when tap count, position, or movement is part of the action, and add matching accessibility actions.
- Never communicate state through colour alone.
- Pointer targets must be easy to acquire, and every action needs a keyboard and accessibility-focus path.
- Use semantic text styles. Scale any necessary custom dimensions with the relevant text style.
- Provide a reduced-motion alternative for large spatial movement.

## Output

Report the affected assistive technology or setting, macOS version, window state, consequence, correction, and exact manual verification steps. Classify unreachable or unnamed actions as blockers.
