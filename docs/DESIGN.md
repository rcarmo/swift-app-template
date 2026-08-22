# macOS 26 design and interaction

## Native composition

Use SwiftUI and macOS system containers before custom drawing. Do not imitate browser, Electron, or iOS chrome. macOS owns traffic lights, title bars, toolbars, sheets, menus, focus rings, materials, window activation, and control metrics.

The template demonstrates the desktop surfaces missing from the general source skills:

- `WindowGroup`, auxiliary `Window`, and `openWindow`;
- `Settings`;
- `Commands`, `CommandGroup`, and `CommandMenu`;
- `@FocusedValue` and `focusedSceneValue` for active-window actions;
- `NavigationSplitView`, `Table`, `.searchable`, and context menus;
- `fileImporter`, `fileExporter`, `Transferable`, `.draggable`, and `.dropDestination`.

Use only the surfaces required by the derived product.

## Windows and scenes

Name windows by user task. Define close/reopen, duplicate-window, restoration, and selection behaviour. Keep the main window useful at narrow, standard, wide, tiled, and full-screen sizes. Auxiliary inspectors must update from shared state and show an explicit unavailable state when selection disappears.

## Commands, focus, keyboard, and pointer

Primary actions belong in menus and use conventional shortcuts when their standard meaning fits. Commands act on the active window through focused values; do not broadcast actions through a global notification bus.

Verify:

- Command-N creation;
- Command-F search focus;
- Escape and Return behaviour where relevant;
- Delete only when focus and selection make the consequence unambiguous;
- focus return after sheets, file panels, and auxiliary windows;
- context-menu parity for pointer workflows;
- no hover-only action;
- no layout jump when hover or drop-target state changes.

## Navigation and dense data

Use `NavigationSplitView` for persistent collection/detail relationships and `NavigationStack` for bounded hierarchy. Keep selection stable through refresh and filtering. Show `ContentUnavailableView` when no detail is selected.

Use `Table` when sorting, columns, alignment, and dense scanning matter. Give columns concise labels, useful minimum widths, monospaced digits for changing numbers, and a discoverable full value when text truncates.

## Files, transfer, and sandbox access

Provide buttons or menu commands for every drag-and-drop operation. `Transferable` defines the data contract; custom previews and drop effects are secondary.

Use SwiftUI file import/export panels for user-selected files. Read imported URLs while security-scoped access is active. Persist a security-scoped bookmark only when the product needs access after the immediate operation. Keep the `com.apple.security.files.user-selected.read-write` entitlement only while file workflows exist.

## States and feedback

Design initial, loading, populated, empty, search-empty, failure, denied, offline, and no-selection states before visual polish. Hide actions that have no meaning in the current state. Show progress for work that is not immediate and surface errors caused by user actions.

Optimistic mutation needs deterministic rollback or undo. Destructive changes need a clear verb and, where feasible, undo rather than repeated confirmation.

## Visual system

Use semantic foreground styles, native materials, SF Symbols, and system text styles. Establish hierarchy through spacing, typography, grouping, and container choice. Avoid fixed pixel recipes copied from web implementations.

Check light and dark appearance, active and inactive windows, system accent changes, Increase Contrast, Reduce Transparency, keyboard focus, hover, selection, disabled state, and drag destination state.

## Accessibility

Every action needs a meaningful text label even when only a symbol is visible. Prefer `Button`, `Menu`, `Toggle`, `Table`, `List`, and other native controls over gesture-only composition.

Test the assembled app with VoiceOver, Voice Control, Full Keyboard Access, the largest supported text settings, Reduce Motion, Reduce Transparency, Differentiate Without Color, and Increase Contrast. Pointer targets must be easy to acquire; macOS does not require an iOS-style universal 44-point control height.

## Performance

Keep `body` pure and cheap. Avoid `AnyView`, unstable identity, repeated sorting/filtering in collection builders, eager large stacks, and broad invalidation. Use `.task` for view-lifetime work. Profile release builds with SwiftUI Instruments, Time Profiler, Allocations, Core Animation, and Energy before adding caches or custom equality.
