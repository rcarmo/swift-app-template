# Layout and composition

## Content first

An app is a container for user content and actions, not a marketing page. Establish hierarchy with system navigation and spacing, keep chrome subordinate, and allow content to use the available window.

## Choosing structure

- Single-purpose utility: one focused window; skip a sidebar when there are only one or two weak destinations.
- Collection and detail: `NavigationSplitView`, selectable `List`, and a meaningful unavailable detail state.
- Hierarchical task: `NavigationStack`.
- Peer destinations: `TabView`, adapting tab/sidebar presentation when appropriate.
- Data-dense macOS content: native `Table` with sorting, selection, keyboard behavior, and concise metadata.
- Settings: `Form` in a platform Settings scene on macOS.

A toolbar holds frequent actions, search, view controls, and creation. Keep it sparse. Use menus for secondary actions and commands for keyboard discoverability. Do not cover or redraw native traffic lights; preserve draggable titlebar space through system composition.

## Sidebars and details

A sidebar needs a real information hierarchy, stable labels and symbols, preserved selection, and acceptable collapse at narrow widths. Avoid loud custom selection backgrounds. Details should maintain context where useful, but a sheet/inspector/panel must match the task rather than an upstream stylistic preference.

## Empty states and progressive disclosure

Use `ContentUnavailableView` where appropriate. Explain why content is absent and offer one useful next action. Hide filters, bulk actions, and metadata that have no meaning without content. Search-empty differs from first-run empty; preserve the query and provide a clear reset.

## Flexible layout

- Use semantic spacing tokens for repeated relationships, not a rigid universal grid.
- Avoid `UIScreen.main.bounds` and fixed window assumptions.
- Cap readable text measure, center it in excess space, and allow text to wrap.
- Use adaptive grids/container proposals instead of fixed column counts.
- Test narrow and wide windows, split-screen, rotation, accessibility text, and long localization.
- Use fixed dimensions only for truly fixed media/control requirements.

## Multi-window and system integration

Decide whether content is a document/window/scene value, how duplicates behave, and how state restores. Consider Settings, commands, import/export, share, Services, menu bar presence, inspectors, and Quick Look only when they serve the product workflow.
