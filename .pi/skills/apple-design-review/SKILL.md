---
name: apple-design-review
description: Review a SwiftUI feature across Apple platforms for native layout, interaction, accessibility, empty/error states, input methods, and visual adaptation.
---

# Apple-platform design review

Read `docs/DESIGN.md` and inspect the actual SwiftUI implementation. If screenshots or previews are available, review both light and dark appearance at compact and expanded sizes.

## Review sequence

1. **Hierarchy:** Is the primary task clear? Does navigation match the content model on each platform?
2. **States:** Are loading, empty, filtered-empty, failure, retry, permission, and offline states useful rather than blank?
3. **System fit:** Are native containers, controls, menus, Settings, symbols, materials, and typography used before custom equivalents?
4. **Accessibility:** Check Dynamic Type, VoiceOver semantics/order, Voice Control labels, 44-point touch targets, contrast, Differentiate Without Color, and Reduce Motion.
5. **Input:** Check touch, pointer, hardware keyboard, macOS menus/shortcuts, tvOS focus/remote, and watchOS crown/compact layout as relevant.
6. **Adaptation:** Resize windows and change size classes. Reject fixed screen bounds and desktop layouts compressed onto small devices.
7. **Feedback:** Every command needs immediate visible state; destructive actions need clear wording and suitable confirmation or undo.
8. **Content workflows:** Consider native search, selection, import/export, share, and drag-and-drop where the product handles documents or media.

## Output

Group findings as blockers, important improvements, and polish. Name the affected platform and accessibility setting. Avoid proposing ornamental custom chrome when a system behavior is available.
