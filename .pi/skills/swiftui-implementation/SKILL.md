---
name: swiftui-implementation
description: Implement or review SwiftUI features in this cross-Apple template using its architecture, data-flow, concurrency, testing, and API rules.
---

# SwiftUI implementation

## Read first

Read `AGENTS.md`, `docs/ARCHITECTURE.md`, and the neighboring feature files. Read `docs/DESIGN.md` when changing presentation or interaction.

## Workflow

1. State the user outcome and supported platforms.
2. List loading, populated, empty, failure, permission, and offline states that apply.
3. Put pure values/operations in `Domain` and external effects behind a narrow `Sendable` protocol.
4. Inject the dependency at the app boundary. Coordinate mutable UI state in an `@MainActor @Observable` type.
5. Build small feature-owned views. Keep local state private and send named intents to the model.
6. Use platform-appropriate `NavigationStack`/`NavigationSplitView`, typed destinations, `sheet(item:)`, and dialogs attached to their triggering control.
7. Use current APIs: `foregroundStyle`, `clipShape(.rect(cornerRadius:))`, value-bound animation, `sensoryFeedback`, `ContentUnavailableView`, format styles, and `task` for asynchronous view work.
8. Add deterministic Swift Testing coverage for pure logic and state transitions.
9. Run `make format`, `make lint`, `make test`, and affected platform builds.

## Reject these patterns

- `ObservableObject`/`@Published` for new code when Observation works.
- service locators, global mutable state, networking or persistence in a view.
- `NavigationView`, destination-bearing legacy links mixed with typed destinations, `AnyView`, unnecessary `GeometryReader`, or `UIScreen.main.bounds`.
- force unwraps/tries, GCD in new concurrency code, `Task.sleep(nanoseconds:)`, broad `Task.detached`, or unchecked sendability.
- custom controls that regress semantics, focus, keyboard behavior, or accessibility.

## Review output

Report genuine issues by file and line, explain the consequence, and show the smallest correction. Prioritise correctness, accessibility, data races, navigation, and performance before style.
