# Swift App Template

A macOS 26 SwiftUI starter built with Swift Package Manager 6.2. The package contains a reusable `AppCore` library, a native `Starter` executable, and Swift Testing coverage.

The template combines the strongest current practices from the projects in `NOTICE.md`:

- Swift 6.2 language mode with MainActor default isolation;
- `InferIsolatedConformances` and `NonisolatedNonsendingByDefault`;
- Observation state owned with `@State` and passed through typed environments;
- compiler-checked `Sendable`, actor-backed services, structured tasks, and explicit `@concurrent` work;
- native macOS windows, Settings, commands, menus, focus, keyboard, pointer, tables, import/export, `Transferable`, and drag and drop;
- Swift Testing plus SwiftFormat and SwiftLint policy;
- release-only dead-code elimination, symbol redaction, debug stripping, and private dSYM preservation;
- SwiftPM executable builds and manual `.app` assembly without an Xcode project.

## Requirements

- macOS 26 or newer
- Swift 6.2 or newer, normally supplied by Xcode 26
- Apple command-line tools, including `codesign`, `plutil`, and `xcrun`
- SwiftFormat and SwiftLint for the `format`, `lint`, `check`, `release-check`, and `dist` targets

Install SwiftFormat and SwiftLint by any method that puts their executables on `PATH`.

## Create an application

Rename the placeholder before adding product code:

```sh
make rename NAME=MyApp BUNDLE_ID=com.example.myapp
make validate
make test
make build
```

`make build` compiles a debuggable development application with SwiftPM 6.2, creates `build/MyApp.app`, substitutes bundle metadata, copies SwiftPM resources, and signs the complete bundle ad hoc. Use `make release` for an optimised, stripped, ad-hoc-signed build.

## Included macOS patterns

| Surface | Example |
|---|---|
| scenes | named `WindowGroup`, auxiliary `Window`, and `Settings` |
| commands | `Commands`, `CommandGroup`, `CommandMenu`, conventional shortcuts |
| active-window actions | `@FocusedValue`, `focusedSceneValue`, and `@Entry` |
| navigation | `NavigationSplitView`, typed selection, search, unavailable states |
| dense data | native sortable/resizable `Table` composition |
| files | sandboxed `fileImporter`, `fileExporter`, bounded decoding, and security-scoped reads |
| transfer | `Transferable`, `CodableRepresentation`, drag and drop |
| input | keyboard, focus, pointer hover/drop state, context menus, deletion, and undo/redo |
| state | `@Observable`, `@State`, `@Bindable`, typed `@Environment` |
| concurrency | MainActor UI defaults, actors, `Sendable`, cancellation, `@concurrent` |
| tests | Swift Testing with sentence-style test names and deterministic fakes |

These are reference implementations, not requirements for every derived product. Remove scenes and capabilities that the product does not use.

## Commands

| Command | Result |
|---|---|
| `make` or `make build` | Compile, assemble, and ad-hoc sign `build/Starter.app` |
| `make package-build` | Compile the `Starter` executable with SwiftPM |
| `make release` | Assemble an optimised, stripped, ad-hoc-signed release application |
| `make hardening-check` | Build and verify release symbol/debug stripping plus the private dSYM |
| `make verify-hardening` | Verify the current release executable and private dSYM without rebuilding |
| `make test` | Run `AppCoreTests` with Swift Testing |
| `make run` | Build and open the application |
| `make install` | Replace `/Applications/Starter.app` and register it with LaunchServices |
| `make register` | Register the local build with LaunchServices |
| `make uninstall` | Remove `/Applications/Starter.app` |
| `make validate` | Check topology, Swift 6.2/macOS 26 settings, scripts, resources, and skills |
| `make workflow-test` | Test Make orchestration with stubs; does not compile Swift |
| `make format` | Apply SwiftFormat and safe SwiftLint fixes |
| `make lint` | Run strict SwiftFormat and SwiftLint checks |
| `make check` | Run validation, lint, tests, and SwiftPM compilation |
| `make release-check` | Run the complete preflight, including hardened release assembly and verification |
| `make icon PNG=icon.png` | Create `build/AppIcon.icns` from a 1024×1024 PNG |
| `CERT_NAME='Developer ID Application: …' NOTARY_PROFILE=starter-notary make dist VERSION=1.0.0` | Run the release preflight, then create a signed, notarised, stapled, verified-checksum release |
| `make clean` | Remove `.build`, `build`, and `dist` |

`build`, `run`, `install`, `register`, `icon`, `notary-setup`, and `dist` require macOS. See `make help` for variables and command descriptions.

## Repository layout

```text
Package.swift                         SwiftPM 6.2 products, targets, and concurrency settings
Sources/AppCore/                      domain, state, services, and reusable macOS views
Sources/Application/StarterApp.swift  scenes and dependency composition
Sources/Application/StarterCommands.swift  menus and keyboard commands
Tests/AppCoreTests/                   Swift Testing domain/model coverage
Resources/Info.plist                  application metadata template
Config/Starter.entitlements           sandbox and user-selected file access
scripts/build-macos-app.sh            .app assembly and local signing
scripts/harden-macos-binary.sh        release symbol redaction, dSYM preservation, and stripping
scripts/verify-macos-hardening.sh      Mach-O release-hardening verification
scripts/release-macos.sh              Developer ID release and notarisation
docs/                                 architecture, design, testing, and release contracts
.pi/skills/                           project-local implementation guidance
```

`Package.swift` and `Resources/Info.plist` both declare macOS 26 and must stay in sync. `scripts/static-checks.sh` enforces the deployment and concurrency settings.

The repository ships one macOS application. GitHub Actions are permanently disabled: `.github/workflows/` contains reference files with a `.disabled` suffix, and validation rejects active workflow YAML.

A future iPadOS application may consume `AppCore` as a local package, with its bundle and platform composition defined at that new application boundary.

## Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Design and interaction](docs/DESIGN.md)
- [Testing and validation](docs/TESTING.md)
- [Direct release runbook](docs/RELEASE.md)
- [Agent instructions](AGENTS.md)
- [Provenance and licences](NOTICE.md)

## Licence

The template is available under the [MIT licence](LICENSE). `NOTICE.md` records the audited sources and the features adopted or rejected from each one.
