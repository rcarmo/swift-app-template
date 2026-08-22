# macOS review matrix

| Surface | Review priorities |
|---|---|
| Main window | lifecycle, title bar, toolbar, resizing, full-screen, restoration, commands |
| Split view | sidebar width, collapse, selection, empty detail, search, keyboard navigation |
| List or table | selection, sorting, filtering, focus, context menus, deletion, large data sets |
| Settings | standard scene, form layout, persistence, keyboard access, help text |
| Sheet, popover, inspector | anchoring, resize behaviour, dismissal, save/cancel semantics, focus return |
| Import/export | sandbox access, open/save panels, security-scoped bookmarks, drag alternatives |
| Appearance | light/dark, active/inactive windows, system tint, contrast, transparency, motion |
| Accessibility | VoiceOver, Voice Control, Full Keyboard Access, text scaling, focus order |
| Failure states | loading, no data, no search results, offline, permission denial, retry |

## Shared code

Default to native macOS composition. Share domain models, services, formatting, state, and views only where reuse is real. Add a platform-specific composition layer when another application target exists and its container, input, density, or lifecycle differs.

## Required state captures

For a meaningful feature, inspect:

- initial and loading;
- populated with short and long content;
- no data and no search results;
- recoverable and unrecoverable failure;
- permission denied or unavailable;
- offline or stale data;
- narrow, standard, wide, and full-screen windows;
- light, dark, and accessibility appearances;
- active selection, focus, hover, and inactive-window state where applicable.
