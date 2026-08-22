# SwiftUI runtime hardening

These are investigation heuristics, not unconditional laws. Verify against supported OS versions and the actual hosting context.

## Structural transitions and hosting

If insertion/removal with `.transition` crashes or destabilizes a hosted SwiftUI tree (sheet, popover, split view, AppKit host), test keeping the view mounted and animating size/opacity/hit-testing instead. Preserve accessibility hidden state. Do not ban transitions globally; record the affected OS/context.

## Layout conflicts

- `frame(maxWidth: .infinity)` plus high `layoutPriority` can starve siblings; inspect proposals and use explicit caps/Spacer where appropriate.
- `fixedSize` makes a view resist compression; reserve it for genuinely inflexible values.
- Rows need deliberate wrapping/truncation and priorities at narrow widths; do not force every text to one line when content is essential.
- Centralize repeated named metrics, but avoid a rigid pixel system across platforms.

## Observation and stale snapshots

Observation tracks property access/mutation; it does not keep independent copied structs in caches synchronized. Derive from one source or rebuild caches after every relevant mutation. Identify mutable reference types by immutable IDs rather than relying on reference equality as value equality.

Read settings/state at commit time to avoid overwriting newer mutations. Test overlapping async saves and reloads.

## Storage and restoration

`@SceneStorage` and restored navigation/window state persist old values. Changing a source default does not migrate existing users. Add a versioned migration or intentionally reset the stored key. Test upgrades, multiple scenes, and corrupted/stale destinations.

## Lists, scroll views, and hover

- `swipeActions` requires supported list/form context; provide context menus/buttons for other containers and non-touch platforms.
- Prefer one reusable row composition rather than forks that drift.
- Keep hover-revealed controls mounted with opacity and hit-testing so geometry does not jump.
- On macOS, use actual hover/focus APIs; do not assume an iOS hover modifier behaves identically.
- Verify selection, focus, keyboard actions, scrolling, and deletion after filtering/reordering.

## Live-run matrix

Repeat rapid toggles, navigation push/pop, modal open/close, window resize, search/filter, delete/undo, background/foreground, appearance changes, Dynamic Type, Reduce Motion, and restoration. Include the lowest supported OS and a lower-spec device/Mac when practical.
