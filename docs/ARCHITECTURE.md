# Architecture

## Goals

The starter optimises for a small codebase that can grow without an early framework commitment. Its boundaries should make behavior testable, dependencies replaceable, and platform-specific presentation localised.

## Layers

### Domain

`Sources/AppCore/Domain` contains value types and pure operations. Domain code should not import SwiftUI. Prefer `struct`, `enum`, `Sendable`, stable identifiers, and explicit transformations.

### Infrastructure

`Sources/AppCore/Infrastructure` defines dependency protocols beside simple implementations. Protocols describe application needs rather than mirroring an SDK. Implementations may call network, persistence, keychain, file, or system APIs.

Keep production credentials outside source control. Perform mutable shared work in an actor or another concurrency-safe type.

### Application

`Sources/AppCore/Application` owns application-level state and coordination. `AppModel` is `@Observable` and `@MainActor`: it updates UI state, invokes dependencies, converts failures into presentable state, and preserves selection.

The root view performs composition, not business logic. The executable under `Sources/Application` owns the model with `@State` and injects it using `.environment()`.

### Features

A feature owns its screens, rows, empty/error/loading states, and local presentation state. Keep each meaningful type in its own file. Views should:

- read immutable values or observable state;
- send named actions to the model;
- avoid network, persistence, and expensive transformations in `body`;
- use `task` for cancellable asynchronous view work;
- use system navigation and presentation APIs.

When a feature grows, create folders such as `Features/Items/Domain`, `Features/Items/Views`, and `Features/Items/Services` rather than a global folder for every type category.

### Design system

`DesignSystem` contains semantic tokens and reusable primitives, not a parallel rendering framework. Prefer system fonts, materials, colors, controls, and spacing before adding custom tokens.

## Dependency direction

- The executable may import `AppCore`.
- Features may depend on domain values and application state.
- Application state depends on domain values and infrastructure protocols.
- Infrastructure implementations conform to those protocols.
- Domain code depends on no higher layer.

Do not introduce a global service locator. Construct dependencies at the app boundary and inject them explicitly.

## State ownership

| State | Owner | Mechanism |
|---|---|---|
| App-wide mutable state | App scene / `AppModel` | `@State` + `@Observable` + environment |
| View-local transient state | Creating view | private `@State` |
| Editable projection of observable state | Consuming view | `@Bindable` |
| Parent-owned value | Child view | value or `@Binding` |
| Durable non-sensitive preference | System preferences | `@AppStorage` in a view |
| Secret | Keychain-backed service | never `@AppStorage` |

Avoid `ObservableObject`, `@Published`, and `@EnvironmentObject` unless interoperability with older code requires them.

## Concurrency

- Compile in Swift 6 language mode with complete strict concurrency.
- Isolate UI state to `@MainActor`.
- Make service protocols `Sendable`.
- Prefer `async`/`await`, task groups, actors, and clocks over callback APIs and dispatch queues.
- Avoid `Task.detached` unless isolation and ownership are proven and documented.
- Propagate cancellation and present failures triggered by user actions.

## Platform adaptation

Share domain, state, and most views. Adapt navigation and interaction where the device differs:

- iPadOS/macOS/visionOS: split navigation where content hierarchy benefits.
- iPhone/tvOS: verify focus, compact width, and push navigation behavior for each feature.
- watchOS: use a compact `NavigationStack`; do not squeeze desktop composition onto the watch.
- macOS: add commands, menus, keyboard shortcuts, Settings, window behavior, import/export, and drag-and-drop where the product requires them.

Use conditional compilation only at clear platform seams. Prefer capability-based shared APIs before introducing wrappers around UIKit or AppKit.

## Persistence growth path

The demo service is intentionally ephemeral. Before choosing persistence, write the required semantics: offline behavior, migration, sync, conflict handling, deletion, export, privacy, and backup. Then provide a service implementation behind a narrow protocol. SwiftData is appropriate only when its model and migration constraints fit those semantics.
