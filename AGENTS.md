# Agent instructions

## Mission

Maintain this repository as a small, modern, macOS-first SwiftUI starter built with Swift Package Manager. Prefer clear Apple APIs and explicit boundaries over abstractions or platform scaffolding added before a product needs them.

## Before changing code

1. Read `README.md` and the relevant file under `docs/`.
2. Inspect `Package.swift`, `Makefile`, and neighboring source files.
3. Record concise refinement answers for feature or behavior changes.
4. Read `.pi/skills/README.md` and load the narrowest matching local skills.

## Local skill routing

| Change | Required local skills |
|---|---|
| SwiftUI feature | `swiftui-implementation`; then relevant domains below |
| state/dependencies/persistence | `swift-architecture` |
| async/tasks/actors | `swift-concurrency` |
| navigation/presentation | `swiftui-navigation` |
| any user interface | `apple-accessibility` and `apple-design-review` |
| performance/profiling | `swiftui-performance` |
| runtime/layout/restoration defects | `swiftui-hardening` |
| typography/custom fonts | `apple-typography` |
| tests | `swift-testing` |
| style/tool configuration | `swift-style-tooling` |
| Package.swift/Make/bundling/CI/icons/rename | `apple-project-workflows` |
| user-facing strings/formatting | `apple-localization` |
| permissions/data/secrets/network/files | `apple-privacy-security` |
| distribution | `apple-release` |

## Architecture rules

- Put value types and pure transformations in `Domain`.
- Define narrow dependency protocols in `Infrastructure`; inject implementations at the app boundary.
- Keep observable UI state `@MainActor` and owned with `@State`.
- Keep views declarative and move dependency calls out of `body`.
- Organise by feature as the app grows; keep one meaningful type per Swift file.
- Do not add a third-party dependency without explaining why an Apple API or small local implementation is insufficient.
- Preserve Swift 6 strict-concurrency correctness. Never silence it with broad `@unchecked Sendable` annotations.
- Keep SwiftPM as the only build graph and dependency source of truth.

## Design rules

- Start with macOS system containers, controls, fonts, colors, symbols, menus, commands, Settings, and presentation APIs.
- Provide loading, empty, filtered-empty, failure, retry, and populated states.
- Support VoiceOver, Voice Control, keyboard/focus, Reduce Motion, increased contrast, and Differentiate Without Color.
- Avoid fixed window dimensions, color-only meaning, hidden labels, fake macOS chrome, and decorative animation.
- Defer iPadOS/iOS adaptation until those product phases begin; do not maintain speculative application targets.

## Style

- Follow the Swift API Design Guidelines and local formatter/linter configurations.
- Aim for 100-character lines; 120 is the formatter limit and 140 is a hard lint error.
- Prefer explicit names, Swift-native APIs, `async`/`await`, actors, format styles, and modern SwiftUI modifiers.
- No force unwraps, force tries, direct `print`, swallowed user-action errors, or secrets in source.

## Build contract

- `Package.swift` defines `AppCore`, the `Starter` executable product, and tests.
- `scripts/build-macos-app.sh` independently assembles the SwiftPM executable into a macOS `.app` and signs the complete bundle.
- `Resources/Info.plist` and `Config/Starter.entitlements` own bundle metadata and capabilities.
- There is no Xcode project, XcodeGen, `xcodebuild`, or Homebrew build dependency.
- Build output, certificates, profiles, keychains, and notarisation credentials must not be committed.

## Required validation

Run the strongest available subset and state exactly what was not run:

```sh
make validate
make workflow-test
make lint
make test
make package-build
make build
```

`make build` requires macOS. Mocked workflow tests prove orchestration only; never claim native compilation or launch validation without real Swift and macOS output.

## Completion checklist

- Behavior has deterministic tests.
- User-visible failures are presented and recoverable where possible.
- macOS behavior, keyboard use, accessibility, and window resizing have been reviewed.
- Documentation and `Package.swift` match implementation.
- No generated project, secrets, or build output are committed.
- Rename changes have been tested in a disposable copy.
- Local skill metadata/index remain valid.
- `NOTICE.md` is updated if new source or substantial guidance is incorporated.
