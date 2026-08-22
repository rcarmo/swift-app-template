# Swift App Template

An opinionated, dependency-free SwiftUI starter for iOS, iPadOS, macOS, Mac Catalyst, tvOS, visionOS, and watchOS.

The template keeps domain and application logic in a testable Swift package and generates native app targets with XcodeGen. It starts with Swift 6 strict concurrency, Observation, Swift Testing, accessible system components, formatting, linting, CI, signing, and notarisation helpers.

## What is included

- **Feature-first SwiftUI source tree** with separate domain, infrastructure, application-state, design-system, and feature layers.
- **Shared `AppCore` package** consumed by generated Xcode targets and tested independently.
- **Adaptive navigation**: `NavigationSplitView` on larger Apple platforms and `NavigationStack` on watchOS.
- **Explicit dependency injection** through the `ItemServing` protocol; no service locator or singleton.
- **Modern state flow** using `@Observable`, `@State`, `@Environment`, and `@Bindable`.
- **Cross-Apple XcodeGen project** for iOS/iPadOS, native macOS, Mac Catalyst, tvOS, visionOS, and watchOS, with distinct Mac bundle identifiers.
- **macOS packaging** using the generated Xcode target, code signing, notarisation, stapling, and checksums.
- **SwiftFormat and SwiftLint policy**, GitHub Actions, tests, static repository checks, app-icon and rename helpers.
- **Agent instructions and 15 reusable local skills** under `AGENTS.md` and `.pi/skills/`, covering SwiftUI, architecture, concurrency, navigation, accessibility, design, typography, performance, runtime hardening, testing, style/tooling, project workflows, localization, privacy/security, and release.

## Requirements

Native app work requires macOS with current Xcode command-line tools. The supplied deployment targets are:

| Platform | Minimum |
|---|---:|
| iOS / iPadOS / Mac Catalyst | 17.0 |
| macOS | 14.0 |
| tvOS | 17.0 |
| visionOS | 1.0 |
| watchOS | 10.0 |

Development tools are installed through Homebrew:

```sh
make bootstrap
```

This installs XcodeGen, SwiftFormat, and SwiftLint from `Brewfile`, then generates `Starter.xcodeproj`.

## Start a new app

Rename before making product changes:

```sh
make rename NAME=MyApp BUNDLE_ID=com.example.myapp
make validate
make bootstrap
```

Then open the generated project:

```sh
open MyApp.xcodeproj
```

The generated `.xcodeproj` is deliberately ignored. Edit `project.yml`, then run `make generate`; do not hand-edit generated project files.

## Common commands

```sh
make help                 # list supported workflows
make validate             # portable shell/JSON/repository checks
make format               # apply SwiftFormat and safe SwiftLint corrections
make lint                 # strict formatting and lint gate
make test                 # SwiftPM tests for AppCore
make build-ios            # simulator build
make build-macos          # generated Xcode macOS build
make build-tvos           # tvOS simulator build
make build-visionos       # visionOS simulator build
make build-watchos        # watchOS simulator build
make app-macos            # generate and build an ad-hoc signed macOS .app
make run-macos            # build and launch the local bundle
```

To create iOS/macOS icon assets and an `.icns` file from a square 1024-pixel PNG (other platforms need platform-specific artwork configured in `project.yml`):

```sh
make icon PNG=path/to/icon-1024.png
```

## Architecture at a glance

```text
Sources/
├── AppCore/
│   ├── Application/       observable state and root composition
│   ├── DesignSystem/      semantic layout and visual tokens
│   ├── Domain/            value types and pure transformations
│   ├── Infrastructure/    dependency protocols and implementations
│   └── Features/          feature-owned SwiftUI views
└── Application/           thin @main scene composition
```

Dependencies point inward:

```text
Application entry → AppCore composition → features → application/domain protocols
                                              infrastructure implements protocols
```

Views render state and send intents. `AppModel` coordinates state transitions. Services perform external work behind `Sendable` protocols. Pure domain transformations remain independent of SwiftUI where practical.

See [Architecture](docs/ARCHITECTURE.md), [Design](docs/DESIGN.md), [Testing](docs/TESTING.md), and [Release](docs/RELEASE.md) for the full contracts. Agent skill routing and upstream-to-local coverage are documented in [`.pi/skills/README.md`](.pi/skills/README.md).

## Release a macOS build

1. Add your Developer ID Application certificate to the keychain.
2. Store App Store Connect notarisation credentials:

   ```sh
   APPLE_ID=you@example.com TEAM_ID=XXXXXXXXXX make notary-setup
   ```

3. Build from an exact release version and supply the certificate name:

   ```sh
   CERT_NAME='Developer ID Application: Your Name (XXXXXXXXXX)' TEAM_ID=XXXXXXXXXX make dist VERSION=0.1.0
   ```

The result is `dist/Starter-0.1.0-macos.zip` plus a SHA-256 file. Secrets stay in the keychain or GitHub Actions secrets; none belong in the repository.

## Upstream acknowledgements

This original template was informed by the following projects:

- [twostraws/swiftui-agent-skill](https://github.com/twostraws/swiftui-agent-skill) — modern SwiftUI API, data-flow, accessibility, navigation, performance, and code-review guidance.
- [airbnb/swift](https://github.com/airbnb/swift) — Swift style principles and formatter/linter policy.
- [tqbf/swiftui-app](https://github.com/tqbf/swiftui-app) — architectural and build-workflow inspiration. No source was copied because the audited repository had no explicit licence.
- [ceorkm/macos-design-skill](https://github.com/ceorkm/macos-design-skill) — macOS interaction and visual-design reference. Its README states MIT, but the audited snapshot had no standalone licence file, so its material was treated as reference rather than copied implementation.

Exact audited revisions and reuse boundaries are recorded in [NOTICE.md](NOTICE.md).

## Licence

This template is available under the MIT License. See [LICENSE](LICENSE). Third-party attribution and licence notices are in [NOTICE.md](NOTICE.md).
