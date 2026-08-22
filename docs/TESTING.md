# Testing and validation

## Test pyramid

1. **Pure unit tests** cover domain transformations, validation, sorting, and formatting.
2. **Model tests** inject deterministic services and verify loading, failure, cancellation, and mutation.
3. **Integration tests** verify real persistence and network adapters behind temporary stores or controlled servers.
4. **UI tests** cover only critical user journeys and behavior that cannot be proven below the UI layer.
5. **Manual platform checks** cover visual quality, accessibility, input methods, lifecycle, permissions, and release installation.

Tests use Swift Testing. Keep data deterministic: fixed identifiers, dates, clocks, and service results. Do not add sleeps to wait for asynchronous behavior.

## Local gates

```sh
make validate       # portable repository checks
make lint           # SwiftFormat + SwiftLint, macOS toolchain
make test           # SwiftPM AppCore tests
make build-ios
make build-macos
make build-tvos
make build-visionos
make build-watchos
```

`make validate` deliberately does not claim compilation. It verifies shell syntax, JSON, whitespace, required files, and common committed-secret patterns on Linux or macOS.

## Feature test checklist

For each feature, cover:

- initial, loading, loaded, empty, filtered-empty, failure, retry, and cancellation states;
- duplicate input and invalid input;
- dependency errors translated into useful UI state;
- selection preservation after refresh and deletion;
- no mutation from a stale asynchronous response;
- localization-sensitive search and formatting;
- accessibility labels and actions for custom composition.

## Manual acceptance matrix

| Area | What to verify |
|---|---|
| iPhone/iPad | compact and regular width, rotation, keyboard avoidance, pointer and multitasking |
| macOS/Catalyst | resize, menus, keyboard, focus, Settings, drag/drop, open/save behavior |
| tvOS | focus order, remote actions, overscan-safe composition |
| visionOS | window sizing, ornaments/volumes if used, comfortable depth and motion |
| watchOS | concise navigation, crown/scroll behavior, readable actions |
| Accessibility | VoiceOver, Voice Control, Dynamic Type, contrast, Reduce Motion, no color-only meaning |
| Lifecycle | relaunch, background/foreground, interrupted tasks, offline transitions |

## CI

The Linux job runs repository checks. The macOS job installs pinned-by-Brewfile tool names, generates the Xcode project, lints, runs package tests, and compiles every app platform. Update runner and simulator destinations as Xcode images evolve.
