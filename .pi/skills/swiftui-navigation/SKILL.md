---
name: swiftui-navigation
description: Design or review typed SwiftUI navigation, split views, tabs, deep links, selection, sheets, popovers, alerts, and confirmation dialogs across Apple platforms.
license: MIT
metadata:
  version: "1.0"
  provenance: Adapted from twostraws navigation guidance and cross-Apple template conventions; see NOTICE.md.
---

# SwiftUI navigation and presentation

Read `references/navigation-and-presentation.md`. Use whenever routes, selection, tabs, sheets, popovers, alerts, dialogs, windows, or deep links change.

## Workflow

1. Define the information hierarchy and restoration/deep-link requirements.
2. Choose `NavigationStack` for push hierarchy or `NavigationSplitView` for persistent selection/detail relationships.
3. Model destinations as stable `Hashable` values; keep navigation state close to the owner of the workflow.
4. Register each destination type once in a hierarchy.
5. Verify compact-width collapse, selection preservation, empty detail, and back behavior.
6. Use item-driven presentation when a modal represents optional data.
7. Attach confirmation dialogs/popovers to the triggering control.
8. Test deep links, invalid/stale destinations, and state restoration where applicable.
9. Review keyboard, focus, remote, pointer, crown, and multi-window behavior on affected platforms.

## Guardrails

- Never use `NavigationView` for new code.
- Do not mix value-driven and destination-closure navigation in one hierarchy without a documented interop reason.
- Do not duplicate `navigationDestination(for:)` registrations for the same type.
- Do not leave a blank detail pane when selection is absent.
- Do not represent optional modal data with an unrelated boolean if `sheet(item:)` fits.
- Avoid global router objects unless multiple independent scenes truly need coordinated routes.

## Output

Describe route values, path/selection ownership, presentation state, compact adaptation, and restoration behavior. Report platform-specific failures explicitly.
