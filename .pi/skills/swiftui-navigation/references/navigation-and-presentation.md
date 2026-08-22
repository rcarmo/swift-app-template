# Navigation and presentation reference

## Containers

- `NavigationStack`: hierarchical push navigation and typed paths.
- `NavigationSplitView`: sidebar/content/detail relationships, especially iPadOS, macOS, and visionOS.
- `TabView`: peer destinations. Store selection as an enum rather than an integer/string.
- watchOS: compact stack and concise destinations.
- tvOS: route hierarchy must preserve predictable focus.

A shared model does not require identical containers. Share destination values and feature screens, then adapt composition at the platform seam.

## Typed destinations

Prefer `NavigationLink(value:)` plus one `navigationDestination(for:)` per value type. Values need stable `Hashable` identity. A route enum is useful when destinations have associated parameters; avoid a router that also becomes a service locator or state dumping ground.

Validate stale IDs from restored paths and deep links. Unknown or deleted content should resolve to an unavailable state, not crash or leave an empty canvas.

## Selection

A split/list selection belongs to the workflow owner. After refresh/deletion/filtering, define whether selection is preserved, moved to the first visible item, or cleared. Filtering must not show detail for a hidden result unless that behavior is intentional.

## Sheets and popovers

- Use `sheet(item:)` for optional selected data.
- Keep dismissal and save/cancel semantics explicit.
- Avoid nested sheets when a navigation stack inside one sheet suffices.
- A popover should remain anchored to the control that opened it and adapt acceptably when the system presents it differently on compact platforms.

## Alerts and dialogs

- Omit a no-op OK action when the alert only acknowledges.
- Use `confirmationDialog` for action choices, especially destructive actions.
- Attach the dialog to its source control so platform animation and anchoring are correct.
- Use clear verbs and state consequences. Destructive operations should offer undo where feasible.

## Commands and windows

On macOS, expose primary actions through commands/menus with conventional shortcuts. Use a `Settings` scene for preferences. Model additional windows with stable values and test scene restoration, duplicate windows, and close/reopen behavior.
