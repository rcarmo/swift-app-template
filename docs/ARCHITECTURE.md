# Architecture

## Goals

The starter is a macOS-first SwiftPM application whose boundaries make behaviour testable, dependencies replaceable, and a future platform wrapper optional rather than structural.

## Package products

`Package.swift` is the sole build graph:

- `AppCore` is the reusable library containing domain values, services, application state, and SwiftUI features.
- `Starter` is the executable product backed by `StarterApp`; it owns the model and scene composition.
- `AppCoreTests` verifies domain and model behaviour with Swift Testing.

## Layers

### Domain

`Sources/AppCore/Domain` contains value types and pure operations. Prefer `struct`, `enum`, `Sendable`, stable identifiers, and explicit transformations.

### Infrastructure

`Sources/AppCore/Infrastructure` defines dependency protocols and implementations. Protocols describe application needs rather than mirroring an SDK. Keep credentials outside source control and mutable shared work concurrency-safe.

### Application

`Sources/AppCore/Application` owns application state and root composition. `AppModel` is `@Observable` and `@MainActor`: it invokes dependencies, maps failures to visible state, and preserves selection.

`Sources/Application/StarterApp.swift` is the SwiftPM executable entry. It owns `AppModel` with `@State`, injects it through the environment, and declares macOS scenes such as Settings.

### Features and design system

Features own their views and local presentation state. Views render state and send named intents; they do not perform persistence, network calls, or expensive transformations in `body`.

`DesignSystem` contains semantic tokens and reusable primitives, not a parallel rendering framework. Prefer system fonts, materials, colours, controls, and spacing.

## Dependency direction

```text
Starter executable → AppCore root/features → application/domain protocols
                                            infrastructure implements protocols
```

Do not introduce a global service locator. Construct dependencies at the executable boundary and inject them explicitly.

## State and concurrency

- App-wide mutable state: `@State` owning an `@Observable @MainActor` model.
- View-local transient state: private `@State`.
- Editable observable projection: `@Bindable`.
- Durable non-sensitive preferences: `@AppStorage`.
- Secrets: Keychain-backed services, never preferences.
- Service protocols are `Sendable`; prefer structured concurrency and propagate cancellation.

## macOS application boundary

SwiftPM compiles the executable. `scripts/build-macos-app.sh` creates the conventional `.app` layout, installs metadata/resources, and signs the complete bundle. This packaging layer contains no application architecture.

A future iPadOS application should consume `AppCore` as a local package and add only the bundle, capabilities, and presentation seams required at that time. It must not displace SwiftPM as the source of truth for shared code.
