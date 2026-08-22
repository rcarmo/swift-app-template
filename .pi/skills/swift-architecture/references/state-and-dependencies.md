# State, dependencies, and persistence

## State ownership table

| Need | Preferred owner/mechanism |
|---|---|
| immutable display input | value parameter |
| child edits parent value | `@Binding` |
| transient state created by a view | private `@State` |
| app/feature shared state | `@MainActor @Observable`, owned with `@State` |
| editable observable projection | local `@Bindable` |
| broadly shared model | typed `@Environment` injection |
| durable non-secret preference | `@AppStorage` in a view or preference service |
| credential/token | keychain-backed service |
| external operation | injected `Sendable` protocol |

`@Observable` classes are `@MainActor` unless another isolation strategy is explicit and justified. Legacy `ObservableObject`, `@Published`, `@StateObject`, `@ObservedObject`, and `@EnvironmentObject` are compatibility tools, not defaults.

## Bindings

Prefer a real binding from `@State`, `@Binding`, or `@Bindable`. Avoid constructing `Binding(get:set:)` in `body`; it hides side effects and can become fragile. Use `onChange` for a separate effect, or expose an intent method if mutation has business semantics.

## Loading state

Represent idle/loading/loaded/failed states explicitly rather than combining unrelated booleans. A reload should define:

- whether existing content remains visible;
- selection preservation rules;
- cancellation behavior;
- stale response behavior;
- user-visible retry and error wording.

Errors caused by user actions must not disappear into `print` or logs.

## Caches and derived values

A copied struct embedded in a cache is a snapshot; Observation does not update it when its source changes. Prefer recomputing from a canonical source. If caching is needed:

1. name the source of truth;
2. identify all invalidation events;
3. rebuild atomically;
4. test mutation followed by read;
5. avoid incremental patch logic unless performance measurement proves it necessary.

Read mutable state at the latest responsible moment. Do not capture a settings snapshot, wait, then overwrite newer changes.

## Persistence decision

Specify durability, model evolution, migration, offline operation, sync/conflicts, atomicity, export, backup, deletion, encryption, and test isolation first. Then choose SwiftData, files, SQLite, CloudKit, or another adapter. Keep the choice behind a protocol shaped by application behavior.

For SwiftData plus CloudKit, validate CloudKit-specific restrictions before implementation; uniqueness and required relationships often need different modeling.
