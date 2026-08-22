# Layout and composition

## Content hierarchy

Use system navigation and spacing to establish hierarchy. Keep application chrome subordinate to content and let content use the available window.

## Structure

- Single-purpose utility: one focused window; omit a sidebar when destinations are weak or few.
- Collection and detail: `NavigationSplitView`, a selectable `List`, and a useful unavailable-detail state.
- Bounded hierarchy: `NavigationStack`.
- Peer destinations: use `TabView` only when a small stable tab set is clearer than a sidebar.
- Dense data: native `Table` with sorting, selection, keyboard behaviour, and concise metadata.
- Settings: `Form` in a macOS `Settings` scene.

Put frequent actions, search, creation, and view controls in a sparse toolbar. Put secondary actions in menus and expose primary operations through commands. Preserve native traffic lights and draggable title-bar space.

## Sidebars and details

A sidebar needs a real hierarchy, stable labels and symbols, preserved selection, and usable narrow-window behaviour. Keep selection styling close to the system appearance. Use a detail view, sheet, inspector, or panel according to the task rather than appearance alone.

## Empty states and progressive disclosure

Use `ContentUnavailableView` where it fits. Explain why content is absent and offer one useful next action. Hide filters, bulk actions, and metadata that have no meaning without content. Distinguish first-run empty from search-empty; preserve the search query and provide a reset.

## Flexible layout

- Use semantic spacing tokens for repeated relationships, not a fixed universal grid.
- Avoid fixed screen or window assumptions.
- Cap readable text measure and let text wrap.
- Use container proposals or adaptive grids instead of fixed column counts.
- Test narrow, standard, wide, tiled, and full-screen windows; large text; and long translations.
- Use fixed dimensions only for media or controls whose dimensions are part of their function.

## Windows and system integration

Define whether content belongs to a window, document, tab, or scene value; how duplicate windows behave; and what state restores. Add Settings, commands, import/export, sharing services, Services, menu bar extras, inspectors, and Quick Look only when they support the product workflow.
