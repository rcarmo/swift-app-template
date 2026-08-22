# Design and interaction

## Start with system behavior

Use standard SwiftUI containers and controls before drawing custom chrome. Native controls inherit accessibility, focus, platform appearance, input behavior, and future OS improvements.

- Use `NavigationStack` or `NavigationSplitView`, never `NavigationView`.
- Use `Label` for an icon with text.
- Use `ContentUnavailableView` for empty, search-empty, and unavailable states.
- Use semantic fonts and hierarchical foreground styles.
- Prefer SF Symbols and generated asset symbols.
- Use `Form` and `LabeledContent` for settings and labelled values.

## Information architecture

A sidebar represents stable destinations or a selectable collection; it is not decoration. Keep the primary action discoverable, preserve selection, and never leave a blank detail pane. On compact platforms, confirm the same hierarchy reads naturally as push navigation.

On macOS, respect the title bar and toolbar rather than imitating web or iOS chrome. Add menu commands and conventional shortcuts for primary actions. Settings belong in a `Settings` scene. Avoid replacing native window controls.

## Accessibility acceptance checks

Every screen must be reviewed with:

- Dynamic Type at accessibility sizes without clipped actions or lost content;
- VoiceOver labels, order, traits, values, headings, and actionable controls;
- Voice Control names that match visible labels;
- keyboard navigation and Full Keyboard Access;
- sufficient contrast in light, dark, increased-contrast, and tinted appearances;
- Differentiate Without Color enabled;
- Reduce Motion enabled, replacing spatial movement with restrained opacity where needed;
- minimum 44-by-44-point touch targets on touch platforms;
- tvOS focus and watchOS compact-layout behavior.

Icon-only visual presentation is acceptable only when the underlying `Button` or `Menu` has a meaningful text label. Decorative images must be hidden from accessibility.

## Layout

Use semantic spacing tokens sparingly. Avoid fixed screen dimensions and `UIScreen.main.bounds`. Allow text to wrap, use readable line lengths, and give controls flexible frames. `GeometryReader` is a last resort after container-relative frames, layout protocols, and visual effects.

Design empty, loading, failure, permission-denied, offline, and populated states before polishing the happy path. Progressive disclosure is preferable to permanently visible controls with no current purpose.

## Color and typography

Use system semantic colors and materials so contrast and vibrancy adapt. Light and dark appearances are separate design contexts, not simple inversions. Do not encode meaning by color alone. Prefer text styles such as `.body`, `.headline`, and `.largeTitle`; use custom sizes only with Dynamic Type scaling.

## Motion and feedback

Animate a state change only when motion clarifies cause, continuity, or hierarchy. Always bind animation to a value. Respect Reduce Motion, avoid gratuitous looping effects, and provide immediate feedback for commands. Use `sensoryFeedback` where haptics are genuinely useful and supported.

## Search, keyboard, and drag-and-drop

- Filtering user text uses `localizedStandardContains`.
- Search should be reachable through the native search field and conventional Find command where applicable.
- Primary macOS actions should have standard menu commands and keyboard shortcuts.
- Content-oriented Mac and iPad apps should consider import/export and drag in/out as first-class workflows.
- Destructive actions require a clear label, appropriate confirmation, and reversible behavior where feasible.

## Platform review

A shared code path is not proof of a good shared design. Review screenshots and interaction on each target. Use previews for states, but validate focus, pointer, keyboard, remote, touch, crown, window resizing, localization, and accessibility on devices or simulators.
