# Platform adaptation matrix

| Platform | Review priorities |
|---|---|
| iPhone | compact navigation, one-handed reach, keyboard avoidance, orientation, Dynamic Type, touch targets |
| iPad | split views, resizing, multitasking, pointer/keyboard, drag/drop, toolbars and inspectors |
| Mac Catalyst | Mac idiom, menus/commands, resizing, pointer/keyboard, distinct bundle/product behavior from native Mac |
| macOS | window/scene lifecycle, titlebar/toolbar, sidebar/table, menus/commands, Settings, focus, hover, import/export, sandbox |
| tvOS | focus engine, remote actions, readable distance, overscan-safe layout, no touch assumptions |
| visionOS | resizable windows, comfortable depth/motion, ornaments/volumes only when useful, gaze/pinch focus |
| watchOS | concise stack, short labels, crown/scroll, glanceable state, minimal entry and modal depth |

## Shared-code decision

Share domain models, services, state machines, formatting, and feature intent. Share views where their interaction and information density remain appropriate. Create a platform-specific composition when the container, input, density, or lifecycle differs. Conditional compilation belongs at these seams, not scattered through business logic.

## Required state captures

For a meaningful feature, review at least:

- initial/loading;
- populated with short and long content;
- no data;
- no search results;
- recoverable and unrecoverable failure;
- permission denied/restricted;
- offline/stale data;
- compact and expanded size;
- light/dark and accessibility text;
- active selection/focus/hover where applicable.
