---
name: swift-concurrency
description: Implement or audit Swift 6.2 concurrency, MainActor default isolation, @concurrent work, Sendable dependencies, task ownership, cancellation, clocks, and race-free UI updates.
license: MIT
metadata:
  version: "1.0"
  provenance: Adapted from twostraws Swift guidance and project-specific Swift 6 policy; see NOTICE.md.
---

# Swift concurrency

Read `Package.swift` and `references/concurrency-checklist.md`. Every target uses Swift 6 language mode with MainActor default isolation, `InferIsolatedConformances`, and `NonisolatedNonsendingByDefault`. Use this skill for every asynchronous service, observable model, stream, task group, actor, sendability, `nonisolated`, or `@concurrent` change.

## Workflow

1. Identify mutable state and assign one isolation domain.
2. Keep UI-facing state on `@MainActor`.
3. Make dependency protocols and cross-task values `Sendable`.
4. Prefer structured `async` functions and task groups to callbacks or detached work.
5. Define which scope owns each `Task` and when cancellation occurs.
6. Propagate cancellation; do not convert it into a user-facing failure accidentally.
7. Prevent stale responses from overwriting newer state.
8. Inject clocks or continuations for deterministic tests instead of sleeping.
9. Run `make test` and `make package-build` with Swift 6.2; fix diagnostics at the boundary rather than weakening package settings or using broad suppressions.

## Reject

- `DispatchQueue.main.async` and global queues in new Swift concurrency code.
- `Task.sleep(nanoseconds:)`; use `Task.sleep(for:)` or an injected clock.
- `Task.detached` without a documented isolation/priority reason.
- mutable shared state outside an actor/global actor/explicit synchronization mechanism.
- broad `@unchecked Sendable`; a narrow suppression requires a written thread-safety proof.
- retaining unstructured tasks without cancellation or lifecycle ownership.
- swallowing errors or cancellation.

## Review output

State the isolation of each mutable object, the task owner, cancellation path, and any value crossing an actor boundary. Prioritise data races and stale writes over stylistic concerns.
