# Navigation and presentation reference

## Containers

- `NavigationSplitView`: persistent sidebar, content, and detail relationships on macOS.
- `NavigationStack`: bounded hierarchical flows within a window or sheet.
- `TabView`: a small set of peer destinations when tabs are clearer than a sidebar. Store selection as an enum.

Shared domain state does not require shared window or navigation structure. Keep macOS composition native unless another application target exists.

## Typed destinations

Prefer `NavigationLink(value:)` plus one `navigationDestination(for:)` per value type. Values need stable `Hashable` identity. A route enum can hold associated parameters; do not turn it into a service locator or general state container.

Validate stale IDs from restored paths and deep links. Unknown or deleted content should resolve to `ContentUnavailableView` or another useful unavailable state.

## Selection

A split-view or list selection belongs to the workflow owner. After refresh, deletion, or filtering, define whether selection stays, moves to the first visible item, or clears. A filtered list must not show detail for a hidden item unless that behaviour is explicit.

## Sheets and popovers

- Use `sheet(item:)` when selected data owns presentation.
- Define save, cancel, and dismissal behaviour.
- Prefer one sheet containing a navigation stack over nested sheets.
- Keep popovers anchored during window resize, scrolling, and toolbar/sidebar changes. Use a sheet or inspector when content outgrows a popover.
- Return focus to the triggering control after dismissal where practical.

## Alerts and dialogs

- Omit a no-op OK action when an alert only acknowledges information.
- Use `confirmationDialog` for action choices, especially destructive actions.
- Attach the dialog to its source control for correct anchoring.
- Use clear verbs and state the consequence. Offer undo where feasible.

## Commands and windows

Expose primary actions through menus and commands with conventional shortcuts. Use a `Settings` scene for preferences. Model additional windows with stable values and test restoration, duplicate-window behaviour, and close/reopen flows.
