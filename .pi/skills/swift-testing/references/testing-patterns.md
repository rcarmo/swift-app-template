# Swift Testing patterns

## Test shape

Use descriptive lower-camel-case function names that state behavior. Keep Arrange/Act/Assert visually clear without ceremonial comments. Prefer one behavioral reason to fail per test, with several related `#expect` statements allowed.

## Suites and isolation

Struct suites are the default. Annotate a suite or test `@MainActor` when it touches main-actor state. Create a fresh system under test per test. Use temporary directories, in-memory stores, unique database names, and teardown for external resources.

## Errors and optionals

Use `#expect(throws:)`/`#require` rather than `try!` or force unwrap. A required value should fail at the point it is absent with useful context.

## Parameterized coverage

Use parameterized tests for parsing, validation, formatting, route mappings, and state tables. Keep cases named/readable; avoid compressing unrelated behavior into one matrix.

## Asynchronous behavior

- Await model/service methods directly.
- Inject a clock or controllable continuation for delayed/debounced behavior.
- Test cancellation separately from failure.
- For overlapping requests, hold continuations and resume them out of order to prove stale results cannot commit.
- Test actor-isolated state from the correct actor.

## Dependency fakes

Prefer a small fake matching the protocol semantics. It may return a value/error, record meaningful requests, or suspend under test control. Avoid a generic mock framework and avoid asserting every internal interaction.

## UI and snapshots

Use previews for rapid state inspection, not as tests. UI tests should use accessibility identifiers only for stable automation hooks; user-facing accessibility labels still need semantic validation. Snapshot tests require a controlled OS/device/font/locale and should focus on stable high-value surfaces.

## Build matrix

`swift test` proves the shared package. Build each generated platform target to catch API availability and conditional compilation. Manually run UI changes on representative devices and the lowest supported OS.
