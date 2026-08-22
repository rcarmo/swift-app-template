# Swift App Template

An opinionated, dependency-free, macOS-first SwiftUI starter built entirely with Swift Package Manager.

The template keeps application logic in a testable `AppCore` library and exposes the native app as a SwiftPM executable. `swift build` compiles it; a small script assembles and signs the macOS `.app`. There is no Xcode project, XcodeGen, `xcodebuild`, or Homebrew requirement.

## What is included

- **Feature-first SwiftUI source tree** with domain, infrastructure, application-state, design-system, and feature layers.
- **SwiftPM library and executable products** for testable logic and the native application.
- **Modern state flow** using Observation, `@State`, `@Environment`, and `@Bindable` under Swift 6 strict concurrency.
- **Native macOS composition** using `NavigationSplitView`, Settings, system controls, semantic styling, keyboard/focus behavior, and accessible states.
- **Manual `.app` assembly** with `Info.plist`, entitlements, optional icon, SwiftPM resource bundles, and bundle-level code signing.
- **Direct Developer ID distribution** with signing, notarisation, stapling, Gatekeeper assessment, and SHA-256 checksums.
- **SwiftFormat and SwiftLint policy**, opt-in CI, release and Actions-cleanup workflows, tests, static checks, icon and rename helpers.
- **15 reusable local skills** under `.pi/skills/` for implementation, design, testing, tooling, privacy, and release work.

## Requirements

- macOS 14 or newer.
- A Swift 6 toolchain, supplied by Xcode Command Line Tools, full Xcode, or a compatible Swift.org toolchain.
- Apple command-line utilities for bundling and signing (`codesign`, `plutil`, and `xcrun`).
- SwiftFormat and SwiftLint only for `make format`, `make lint`, and `make check`. Install them however you prefer; Homebrew is optional.

No Xcode project or IDE is needed for normal development.

## Start a new app

```sh
make rename NAME=MyApp BUNDLE_ID=com.example.myapp
make validate
make test
make build
```

The signed local app is written to `build/MyApp.app`.

## Common commands

```sh
make help                 # list supported workflows
make                      # SwiftPM build, assemble, and ad-hoc sign the app
make package-build        # compile only with SwiftPM
make run                  # build and open build/Starter.app
make install              # copy the app to /Applications
make test                 # SwiftPM tests for AppCore
make validate             # repository, script, resource, and skill checks
make workflow-test        # mocked SwiftPM/Make orchestration checks
make format               # optional SwiftFormat/SwiftLint corrections
make lint                 # optional strict formatting/lint gate
make icon PNG=icon.png    # create build/AppIcon.icns from a 1024-square PNG
make clean
```

## Architecture

```text
Package.swift
├── AppCore library
│   ├── Application/       observable state and root composition
│   ├── DesignSystem/      semantic layout and visual tokens
│   ├── Domain/            value types and pure transformations
│   ├── Infrastructure/    dependency protocols and implementations
│   └── Features/          feature-owned SwiftUI views
└── Starter executable
    └── Sources/Application/StarterApp.swift
```

The executable owns the model and injects it into `AppCore`. SwiftPM remains the source of truth for products, targets, dependencies, deployment version, compilation, and tests.

The template is intentionally Mac-first. A future iPadOS application can consume `AppCore` as a local Swift package when that product phase begins; no iPadOS or iOS bundle scaffolding is maintained prematurely.

See [Architecture](docs/ARCHITECTURE.md), [Design](docs/DESIGN.md), [Testing](docs/TESTING.md), and [Release](docs/RELEASE.md).

## Release a macOS build

1. Add a Developer ID Application certificate to the keychain.
2. Store notarisation credentials:

   ```sh
   APPLE_ID=you@example.com TEAM_ID=XXXXXXXXXX make notary-setup
   ```

3. Build from an exact version:

   ```sh
   CERT_NAME='Developer ID Application: Your Name (XXXXXXXXXX)' \
   make dist VERSION=0.1.0
   ```

The result is `dist/Starter-0.1.0-macos.zip` plus a SHA-256 file.

## Implementation references

- [rcarmo/EditorBridge](https://github.com/rcarmo/EditorBridge) — first-party MIT-licensed precedent for SwiftPM library/executable products, manual macOS `.app` assembly, and bundle-level signing.
- [tqbf/swiftui-app](https://github.com/tqbf/swiftui-app) — earlier high-level SwiftPM-only macOS build inspiration. No source was copied because the audited repository had no explicit licence.
- [twostraws/swiftui-agent-skill](https://github.com/twostraws/swiftui-agent-skill) — modern SwiftUI API, data-flow, accessibility, navigation, performance, and review guidance.
- [airbnb/swift](https://github.com/airbnb/swift) — Swift style principles and formatter/linter policy.
- [ceorkm/macos-design-skill](https://github.com/ceorkm/macos-design-skill) — macOS interaction and visual-design reference.

Exact revisions, licences, and reuse boundaries are recorded in [NOTICE.md](NOTICE.md).

## Licence

This template is available under the MIT License. See [LICENSE](LICENSE). Third-party attribution and licence notices are in [NOTICE.md](NOTICE.md).
