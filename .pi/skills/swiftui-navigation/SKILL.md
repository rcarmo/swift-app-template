---
name: swiftui-navigation
description: Design or review typed macOS SwiftUI navigation, split views, tabs, deep links, selection, sheets, popovers, alerts, dialogs, and windows.
license: MIT
metadata:
  version: "2.0"
  provenance: Adapted from twostraws navigation guidance and this template's macOS conventions; see NOTICE.md.
---

# SwiftUI navigation and presentation

Read `references/navigation-and-presentation.md` whenever routes, selection, tabs, sheets, popovers, alerts, dialogs, windows, or deep links change.

## Workflow

1. Define the information hierarchy plus restoration and deep-link requirements.
2. Choose `NavigationSplitView` for persistent selection/detail relationships and `NavigationStack` for a bounded hierarchy.
3. Model destinations as stable `Hashable` values and keep navigation state with the workflow owner.
4. Register each destination type once in a hierarchy.
5. Verify narrow-window behaviour, split-view collapse, selection preservation, empty-detail handling, and back behaviour in stack flows.
6. Use item-driven presentation when a modal represents optional data.
7. Attach confirmation dialogs and popovers to the triggering control.
8. Test invalid or stale destinations, deep links, and restoration where applicable.
9. Review keyboard commands, focus, pointer, VoiceOver, Voice Control, and multi-window behaviour.

## Guardrails

- Do not use `NavigationView` for new code.
- Do not mix value-driven and destination-closure navigation in one hierarchy without a documented interoperability reason.
- Register each `navigationDestination(for:)` type once per hierarchy.
- Show a useful unavailable state when detail selection is absent.
- Use `sheet(item:)` when optional data owns modal presentation.
- Avoid a global router unless independent scenes need coordinated routes.

## Output

Describe route values, path or selection ownership, presentation state, narrow-window behaviour, restoration, and the manual macOS checks performed. Report failures with their window and input context.
