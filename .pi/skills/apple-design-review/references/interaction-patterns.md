# Interaction patterns

## Keyboard and commands

Expose primary actions through menus and commands with conventional shortcuts. Use Command-N, Command-F, Command-S, Command-W, Command-comma, Escape, Delete, and Return only when their standard meanings fit. Labels, tooltips, and menus should make shortcuts discoverable.

## Search

Use `.searchable` where it matches the navigation hierarchy. Preserve the query, provide a search-empty state and clear action, and use `localizedStandardContains` for local user-facing matching. A command palette can unify a large action set, but it must remain keyboard accessible and must not replace ordinary menus or search.

## Feedback and motion

Give each action an immediate state or progress response. Animate only when motion clarifies cause, continuity, or hierarchy. Bind animation to state and provide a reduced-motion path. Prefer system progress, alerts, undo, notifications, inline status text, or toolbar/sidebar status areas over custom toasts.

## Optimistic updates

Use optimistic updates only when rollback is safe and understandable. Preserve the original value, commit local state, perform the operation, and reconcile success or failure. Reject stale responses and offer undo for destructive or high-impact operations.

## Drag and drop, import, export, and sharing

For content applications, evaluate drag-in and drag-out flows. Use transferable types and meaningful previews. Provide an accessible Import, Export, Share, Copy, or menu command alternative. Validate sandbox file access and security-scoped bookmarks where required.

## Hover, focus, and selection

Hover can reveal detail but cannot be the only route to an action. Keep hover controls from changing row geometry; pair them with context menus and keyboard commands. Preserve visible keyboard focus and selection through list, table, inspector, and modal transitions.

## Onboarding

Use onboarding only when a useful empty state and progressive disclosure cannot explain the product. Keep it short, action-oriented, dismissible, repeatable from Help, and accessible. Do not block the main task behind a decorative tour.
