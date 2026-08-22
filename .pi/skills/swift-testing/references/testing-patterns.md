# Swift Testing patterns

## Test shape

Use descriptive lower-camel-case names that state behaviour. Keep setup, action, and expectations visually clear without ceremonial comments. Prefer one behavioural reason to fail per test; several related `#expect` statements are acceptable.

## Suites and isolation

Struct suites are the default. Mark a suite or test `@MainActor` when it uses main-actor state. Create a fresh system under test per test. Use temporary directories, in-memory stores, unique database names, and cleanup for external resources.

## Errors and optionals

Use `#expect(throws:)`, `#require`, or a throwing helper rather than `try!` or force unwraps. Fail where a required value is absent and include useful context.

## Parameterised coverage

Use parameterised tests for parsing, validation, formatting, route mappings, and state tables. Keep cases named and readable; do not compress unrelated behaviour into one matrix.

## Asynchronous behaviour

- Await model or service methods directly.
- Inject a clock or controllable continuation for delayed and debounced work.
- Test cancellation separately from failure.
- Hold and resume continuations out of order to prove stale requests cannot commit.
- Test actor-isolated state from the correct actor.

## Dependency fakes

Use a small fake that matches protocol semantics. It can return a value or error, record meaningful requests, or suspend under test control. Avoid a generic mock framework and assertions on every internal call.

## UI and snapshots

Previews help inspect states but are not tests. UI automation may use accessibility identifiers as stable hooks, while user-facing labels still need semantic review. Snapshot tests need a controlled macOS version, appearance, text settings, locale, window size, and rendering scale; use them only for stable high-value surfaces.

## Build and application evidence

`swift test` runs the `AppCoreTests` target. `make package-build` compiles the `Starter` executable for the package's declared macOS target. Neither proves the `.app` layout, plist substitution, entitlements, signing, launch behaviour, menus, focus, or accessibility.

Run `make build` on macOS for bundle evidence and manually exercise affected UI on the lowest supported macOS version and representative window/input configurations. If a future iPadOS application is added, define and document its own build and device/simulator matrix at that time.
