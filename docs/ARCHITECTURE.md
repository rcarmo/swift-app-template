# Architecture

## Package baseline

The starter is a macOS 26 application built with SwiftPM 6.2. `Package.swift` is the build graph and configures every target with:

```swift
.defaultIsolation(MainActor.self)
.enableUpcomingFeature("InferIsolatedConformances")
.enableUpcomingFeature("NonisolatedNonsendingByDefault")
```

The package uses Swift 6 language mode. Main-actor default isolation makes ordinary application and UI code safe by default. Domain values, service protocols, codecs, and other deliberately reusable code opt out with `nonisolated`. Work that must execute concurrently declares `@concurrent` at the function boundary.

## Products and targets

- `AppCore` contains domain values, services, application state, design tokens, and reusable SwiftUI features.
- `Starter` is the executable product backed by `StarterApp`.
- `StarterApp` owns scene composition and platform process concerns.
- `AppCoreTests` verifies domain and model behaviour with Swift Testing.

## Layers

### Domain

`Sources/AppCore/Domain` contains immutable or value-semantic data and pure transformations. Values crossing isolation boundaries conform to `Sendable`. `Item` also demonstrates `Codable` and `Transferable` with a custom `UTType`.

### Infrastructure

`Sources/AppCore/Infrastructure` defines narrow `Sendable` protocols. Mutable services are actors. `DemoItemService` shows an actor-backed dependency and an explicit `@concurrent` operation. `ItemFileCodec` keeps file decoding off the main actor while preserving security-scoped resource access.

Use `@preconcurrency import` only for a legacy module whose concurrency annotations are unavailable. Do not add `@unchecked Sendable` without a documented synchronisation proof and a narrow lint suppression.

### Application

`AppModel` is `@Observable`. MainActor default isolation applies without a redundant annotation. The executable owns it with `@State` and injects it through the typed environment.

`RootContentView` derives filtered values, renders state, and sends named intents to the model. It uses `@Bindable` for editable projection and focused scene values for active-window commands.

### macOS scene boundary

`StarterApp` demonstrates:

- a named `WindowGroup` for main content;
- auxiliary inspector and table windows opened by stable IDs;
- a `Settings` scene;
- commands and conventional keyboard shortcuts;
- dependency and model ownership.

Remove unused scenes from a derived product. Do not keep capabilities merely because the template demonstrates them.

### Features and design system

Feature folders own views and local presentation state. The item feature demonstrates split navigation, search, list selection, context menus, drag and drop, import/export, empty/error/loading states, a dense table, and auxiliary detail presentation.

`DesignSystem` holds named relationships that repeat. Native control metrics, materials, typography, focus, and window chrome remain under macOS control.

## Dependency direction

```text
Starter executable → AppCore views/model → domain protocols
                                      ↘ actor-backed infrastructure
```

Construct dependencies at the executable boundary. Do not use a service locator or mutable singleton.

## State and concurrency

- application and UI state: MainActor by default;
- root observable ownership: `@State`;
- child observable projection: `@Bindable`;
- view-local state: private `@State`;
- focus: `@FocusState` and `@FocusedValue`;
- non-sensitive preferences: `@AppStorage` in views or a preference service;
- credentials: injected Keychain service;
- mutable shared services: actors;
- cross-isolation values and protocols: `Sendable`;
- view-lifetime tasks: `.task` or `.task(id:)`;
- concurrent CPU or blocking work: a narrow `@concurrent` function with Sendable inputs and outputs.

Cancellation is not a user-visible failure. `AppModel.reload()` restores an idle or loaded state when cancellation occurs.

## Application bundle

SwiftPM compiles the executable. `scripts/build-macos-app.sh` creates the `.app`, substitutes name, bundle identifier, version and build metadata, copies resource bundles and the optional icon, then signs the complete bundle.

The current bundler handles one executable plus SwiftPM resource bundles. Add explicit inside-out signing and embedding rules before introducing frameworks, helpers, extensions, XPC services, or plug-ins.

A future iPadOS application should consume `AppCore` only when that product phase starts. It must supply its own bundle, capabilities, scenes, and platform-specific composition.
