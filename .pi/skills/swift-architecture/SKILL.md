---
name: swift-architecture
description: Design or review feature boundaries, Observation state ownership, dependency injection, persistence seams, caching, and data flow in this SwiftUI template.
license: MIT
metadata:
  version: "1.0"
  provenance: Adapted from twostraws data-flow guidance and independently reimplemented template architecture; see NOTICE.md.
---

# Swift architecture and data flow

Read `docs/ARCHITECTURE.md`, then `references/state-and-dependencies.md`. Use this skill before introducing a model, service, store, persistence mechanism, cache, or app-wide state.

## Workflow

1. Write the behaviour and invariants without UI terminology.
2. Decide whether it is a value, pure operation, external capability, or mutable application state.
3. Put values/pure operations in `Domain`.
4. Define external needs as narrow `Sendable` protocols in `Infrastructure`.
5. Implement dependencies separately and construct them at the app boundary.
6. Keep view-facing shared state in a main-actor-isolated `@Observable` type; rely on the package default rather than repeating `@MainActor`.
7. Own that model once with `@State`; pass via `@Environment` or explicit parameters; expose editable projections through `@Bindable`/`@Binding`.
8. Model asynchronous UI state explicitly and test each transition.
9. Document persistence, migration, sync, conflict, deletion, privacy, and backup semantics before selecting storage.

## Guardrails

- No global service locator, mutable singleton, or hidden dependency lookup.
- No networking, persistence, keychain, or business rules in a view.
- No `@AppStorage` inside an `@Observable` model and no secrets in `@AppStorage` anywhere.
- No cached derived collection without clear invalidation.
- No third-party architecture framework merely to avoid writing small explicit types.
- Do not create a view model per view by reflex; add state coordination only when behaviour needs an owner or test seam.

## Review output

Draw the ownership and dependency flow, identify competing sources of truth and stale snapshots, then propose the smallest boundary correction. Include migration implications when storage changes.
