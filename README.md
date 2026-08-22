# Swift App Template

A macOS 14 SwiftUI starter built with Swift Package Manager. The package contains a reusable `AppCore` library, a native `Starter` executable, and Swift Testing coverage.

`swift build` compiles the executable. `scripts/build-macos-app.sh` then creates `build/Starter.app`, installs bundle metadata and resources, and signs the complete application. The repository has no Xcode project or XcodeGen configuration.

## Requirements

- macOS 14 or newer
- Swift 6
- Apple command-line tools, including `codesign`, `plutil`, and `xcrun`
- SwiftFormat and SwiftLint for the optional `format`, `lint`, and `check` targets

Homebrew is not part of the build. Install the optional quality tools by any method that puts their executables on `PATH`.

## Create an application

Rename the placeholder before adding product code:

```sh
make rename NAME=MyApp BUNDLE_ID=com.example.myapp
make validate
make test
make build
```

`make build` creates an ad-hoc-signed local application at `build/MyApp.app`.

## Commands

| Command | Result |
|---|---|
| `make` or `make build` | Compile, assemble, and ad-hoc sign `build/Starter.app` |
| `make package-build` | Compile the `Starter` executable with SwiftPM |
| `make test` | Run `AppCoreTests` with Swift Testing |
| `make run` | Build and open the application |
| `make install` | Replace `/Applications/Starter.app` with the local build |
| `make uninstall` | Remove `/Applications/Starter.app` |
| `make validate` | Check repository structure, scripts, resources, skills, and common secret patterns |
| `make workflow-test` | Test Make target orchestration with stub commands; does not compile Swift |
| `make format` | Apply SwiftFormat and safe SwiftLint fixes |
| `make lint` | Run strict SwiftFormat and SwiftLint checks |
| `make check` | Run validation, lint, tests, and SwiftPM compilation |
| `make icon PNG=icon.png` | Create `build/AppIcon.icns` from a 1024×1024 PNG |
| `CERT_NAME='Developer ID Application: …' NOTARY_PROFILE=starter-notary make dist VERSION=1.0.0` | Create a signed, notarised, stapled, checksummed release |
| `make clean` | Remove `.build`, `build`, and `dist` |

`build`, `run`, `install`, `icon`, `notary-setup`, and `dist` require macOS. See `make help` for variables and command descriptions.

## Repository layout

```text
Package.swift                       SwiftPM products and targets
Sources/AppCore/                    reusable domain, state, services, and views
Sources/Application/StarterApp.swift  executable scene and dependency composition
Tests/AppCoreTests/                 domain and model tests
Resources/Info.plist                application metadata template
Config/Starter.entitlements         sandbox and capabilities
scripts/build-macos-app.sh          .app assembly and local signing
scripts/release-macos.sh            Developer ID release and notarisation
docs/                               architecture, design, testing, and release contracts
.pi/skills/                         project-local implementation guidance
```

`Package.swift` and `Resources/Info.plist` both declare the macOS minimum version and must stay in sync. The build script copies the plist into the application and substitutes the application name, bundle identifier, marketing version, and build number.

The repository ships one macOS application target. A future iPadOS application may consume `AppCore` as a local package, with its bundle and platform-specific composition defined at that new application boundary.

## Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Design and interaction](docs/DESIGN.md)
- [Testing and validation](docs/TESTING.md)
- [Direct release runbook](docs/RELEASE.md)
- [Agent instructions](AGENTS.md)
- [Provenance and licences](NOTICE.md)

## Licence

The template is available under the [MIT licence](LICENSE). `NOTICE.md` records the audited implementation and guidance references, including the MIT-licensed SwiftPM application pattern in [rcarmo/EditorBridge](https://github.com/rcarmo/EditorBridge).
