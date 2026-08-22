---
name: apple-accessibility
description: Implement or audit accessibility for SwiftUI across VoiceOver, Voice Control, Dynamic Type, contrast, Reduce Motion, Differentiate Without Color, focus, and input methods.
license: MIT
metadata:
  version: "1.0"
  provenance: Adapted from twostraws accessibility guidance and Apple-platform review practice; see NOTICE.md.
---

# Apple accessibility

Read `references/accessibility-checklist.md`. Use for every user-interface feature, custom control, image, animation, chart, drag/drop interaction, or input workflow.

## Workflow

1. Identify semantics before visual styling: label, value, hint, traits, action, grouping, and heading level.
2. Prefer native controls because they carry behavior and accessibility automatically.
3. Verify Dynamic Type and flexible layout at accessibility sizes.
4. Verify VoiceOver order, focus, actions, and announcements.
5. Verify Voice Control uses visible, stable names.
6. Check light/dark, increased contrast, and Differentiate Without Color.
7. Check Reduce Motion and Reduce Transparency where relevant.
8. Test keyboard/Full Keyboard Access, pointer, tvOS focus, and watchOS compact operation.
9. Document manual checks not automatable.

## Guardrails

- An icon-only visual button still needs a text label: use `Button("Label", systemImage:...)` and `.labelStyle(.iconOnly)` if required visually.
- Decorative images are hidden; meaningful images have concise labels.
- Use `Button`, not `onTapGesture`, for ordinary actions. If tap count/location is essential, add the correct accessibility traits and actions.
- Never encode state using color alone.
- Touch interactions need at least a 44-by-44-point target.
- Do not force point-sized fonts without Dynamic Type scaling.
- Large spatial motion needs a reduced-motion alternative.

## Output

Report issues by assistive technology/setting and platform. Distinguish blockers (unreachable or unlabeled actions) from improvements. Include exact manual verification steps.
