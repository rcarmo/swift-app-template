# Swift 6.2 concurrency checklist

## Package defaults

Every target keeps `.defaultIsolation(MainActor.self)`, `InferIsolatedConformances`, `NonisolatedNonsendingByDefault`, and Swift 6 language mode. Do not remove a setting to silence a diagnostic.

## Isolation

- Ordinary application and UI declarations inherit MainActor isolation from the package default; do not repeat the annotation without a reason.
- Mark domain values, dependency protocols, and other deliberately reusable declarations `nonisolated` when they must cross isolation boundaries.
- Use `@concurrent` on a narrow async function only when its work should leave caller isolation. Inputs, captured state, and outputs must be `Sendable`.
- Actors protect mutable service state such as caches, refresh tokens, or connection pools.
- Immutable value types crossing boundaries conform to `Sendable` naturally.
- Closures stored or passed to concurrent APIs are `@Sendable` where required.
- Do not add `MainActor.run` when already isolated to the main actor.

## Task ownership

| Pattern | Use |
|---|---|
| `.task` | view-lifetime work; automatically cancelled |
| `.task(id:)` | restart work when an input changes |
| `async let` | fixed child operations scoped to a function |
| task group | dynamic structured children |
| stored `Task` | model/service work needing explicit cancellation |
| `@concurrent` function | deliberate concurrent work with a typed isolation boundary |
| detached task | exceptional unstructured work with no inherited isolation; review carefully |

A stored task must be cancelled on replacement and at the owning lifecycle boundary. Avoid retain cycles between an object and its task.

## Cancellation

- Check cancellation in loops and before expensive commits.
- Let `CancellationError` propagate unless the API intentionally translates it.
- Do not show “failed” UI for expected navigation cancellation.
- Network/file adapters should close resources promptly.

## Ordering and stale results

If requests can overlap, use one of:

- cancel the previous task;
- attach a request generation/token and commit only the latest;
- serialize in an actor;
- model operations as an `AsyncSequence` with deliberate ordering.

Test a slow old response arriving after a fast new one.

## Time

Use `Task.sleep(for:)` only in production behaviour that genuinely waits. For tests, inject a `Clock` or a controllable dependency. Never make a test rely on wall-clock timing.

## Legacy interop

Wrap callback APIs with checked continuations, resume exactly once, and honour cancellation if the legacy API can cancel. Use `@preconcurrency import` only as a scoped migration aid after reviewing the underlying thread-safety contract.
