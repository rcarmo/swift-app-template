# SwiftUI runtime hardening

These are investigation heuristics, not unconditional laws. Verify them against supported macOS versions and the actual SwiftUI/AppKit hosting context.

## Structural transitions and hosting

If insertion/removal with `.transition` crashes or destabilizes a hosted SwiftUI tree (sheet, popover, split view, AppKit host), test keeping the view mounted and animating size/opacity/hit-testing instead. Preserve accessibility hidden state. Do not ban transitions globally; record the affected OS/context.

## Layout conflicts

- `frame(maxWidth: .infinity)` plus high `layoutPriority` can starve siblings; inspect proposals and use explicit caps/Spacer where appropriate.
- `fixedSize` makes a view resist compression; reserve it for genuinely inflexible values.
- Rows need deliberate wrapping/truncation and priorities at narrow widths; do not force every text to one line when content is essential.
- Centralise repeated named metrics, but avoid a rigid pixel system that ignores window size, text scaling, and system control metrics.

## Observation and stale snapshots

Observation tracks property access/mutation; it does not keep independent copied structs in caches synchronized. Derive from one source or rebuild caches after every relevant mutation. Identify mutable reference types by immutable IDs rather than relying on reference equality as value equality.

Read settings/state at commit time to avoid overwriting newer mutations. Test overlapping async saves and reloads.

## Storage and restoration

`@SceneStorage` and restored navigation/window state persist old values. Changing a source default does not migrate existing users. Add a versioned migration or intentionally reset the stored key. Test upgrades, multiple scenes, and corrupted/stale destinations.

## Lists, scroll views, and hover

- Do not design a macOS workflow around `swipeActions`; provide visible controls, context menus, and keyboard commands appropriate to the container.
- Prefer one reusable row composition rather than forks that drift.
- Keep hover-revealed controls mounted with opacity and hit-testing so geometry does not jump.
- Use the macOS hover and focus APIs in the actual hosting context; verify pointer and Full Keyboard Access behaviour live.
- Verify selection, focus, keyboard actions, scrolling, and deletion after filtering/reordering.

## Live-run matrix

Repeat rapid toggles, navigation changes, modal open/close, window resize/tile/full-screen, search/filter, delete/undo, app activation changes, appearance changes, text scaling, Reduce Motion, and restoration. Include macOS 14 and a lower-spec supported Mac when practical.
