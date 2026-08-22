# Interaction patterns

## Keyboard and commands

On macOS and iPad keyboard contexts, expose primary actions through menus/commands and conventional shortcuts. Prefer Command-N, Command-F, Command-S, Command-W, Command-comma, Escape, Delete, and Return only when their standard meanings fit. Button labels/tooltips and menus should make shortcuts discoverable; do not build a custom keycap UI by default.

## Search

Choose the native `.searchable` placement that matches navigation. Search should preserve query, show search-empty state, support clear/cancel, and use `localizedStandardContains` for local user-facing matching. A command palette is justified only when it unifies many actions/destinations; it must be fully keyboard accessible and not replace ordinary menus/search.

## Feedback and motion

Every action needs immediate state or progress feedback. Animate only to clarify cause, continuity, or hierarchy. Bind animation to state, preserve structural identity when needed, and provide a reduced-motion path. Use system progress, alerts, undo, notifications, or status regions rather than a custom toast for every event.

## Optimistic updates

Use optimistic UI only when rollback is safe and understandable. Keep the original value, commit the local state, perform the operation, then reconcile success/failure. Prevent stale responses and offer undo for destructive/high-impact operations.

## Drag and drop, import/export, share

For content/document apps, evaluate both drag in and drag out. Use transferable types and meaningful previews. Always provide an accessible non-drag alternative such as Import, Export, ShareLink, Copy, or a menu command. Validate file access and sandbox bookmarks where required.

## Hover, focus, and selection

Hover is enhancement, never the sole route to an action. Reveal actions without changing row geometry; pair with context menus and keyboard commands. Preserve visible focus and selection. tvOS focus movement must be predictable and watchOS interactions concise.

## Onboarding

Add onboarding only when the product cannot teach itself through a good empty state and progressive disclosure. Keep it short, action-oriented, dismissible, repeatable from Help, and accessible. Never block core use behind a decorative multi-page tour.
