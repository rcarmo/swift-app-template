# Agent instructions

## Repository contract

This repository is a macOS 26 SwiftUI application built with Swift Package Manager 6.2 and Swift 6.2 language mode.

- `Package.swift` defines the `AppCore` library, `Starter` executable product, deployment target, and tests.
- `Sources/Application/StarterApp.swift` owns scene and dependency composition.
- `Resources/Info.plist` is a template. `scripts/build-macos-app.sh` substitutes the application name, bundle identifier, version, and build number when it assembles the `.app`; release assembly preserves a private dSYM, strips the distributed executable, signs it, and verifies the hardening result.
- `Config/Starter.entitlements` defines sandbox and capability settings.
- The build has no Xcode project, XcodeGen step, `xcodebuild` call, or package-manager bootstrap.
- Build output, certificates, provisioning profiles, keychains, and notarisation credentials stay outside Git.

Read `README.md` and the relevant file under `docs/` before editing. Use `Package.swift`, `Makefile`, and neighbouring source files as implementation evidence.

## Skill routing

Read `.pi/skills/README.md`, then load only the skills required by the change. Common routes:

| Change | Skills |
|---|---|
| SwiftUI feature | `swiftui-implementation` plus the relevant domains below |
| state, dependencies, persistence | `swift-architecture` |
| asynchronous work | `swift-concurrency` |
| navigation or presentation | `swiftui-navigation` |
| user interface | `apple-accessibility`, `apple-design-review` |
| tests | `swift-testing` |
| style configuration | `swift-style-tooling` |
| package, Make, bundling, CI, icons, rename | `apple-project-workflows` |
| localisation or formatting | `apple-localization` |
| permissions, data, files, network, secrets | `apple-privacy-security` |
| signing or distribution | `apple-release` |

## Code rules

- Put value types and pure transformations in `Domain`.
- Define narrow dependency protocols in `Infrastructure` and inject implementations at the executable boundary.
- Keep mutable UI state `@MainActor`; own the root observable model with `@State`.
- Keep dependency calls and business rules out of `View.body`.
- Organise code by feature and keep one meaningful type per Swift file.
- Prefer SwiftUI and system controls. Isolate an AppKit bridge when SwiftUI lacks the required capability.
- Do not add a package dependency without explaining why an Apple API or a local implementation is insufficient.
- Preserve MainActor default isolation, `InferIsolatedConformances`, `NonisolatedNonsendingByDefault`, and Swift 6.2 strict concurrency. Use `nonisolated` and `@concurrent` only at deliberate boundaries; do not suppress checking with broad `@unchecked Sendable` conformance.
- Do not add speculative application targets. A second platform starts with its own explicit product requirement.

Follow the local SwiftFormat and SwiftLint configurations. Use British spelling in documentation. Do not use force unwraps, force tries, direct `print`, swallowed user-action errors, or committed secrets.

## Validation

Run the commands that apply and report any command not run:

```sh
make validate
make workflow-test
make lint
make test
make package-build
make build
make hardening-check
```

`make build` requires macOS and verifies app assembly plus code signing. `make hardening-check` additionally verifies release optimisation, symbol/debug stripping, and private dSYM UUID matching. `make workflow-test` uses stubs and provides no compilation evidence.

For a rename change, run the helper in a disposable copy and check for stale placeholder names. For a release change, verify tag/version handling, signing order, notarisation archive order, final checksum contents, and downloaded-asset verification.

## Completion checks

- Tests cover changed behaviour and failure paths.
- The assembled application has been run for non-trivial UI changes.
- Keyboard, focus, window resizing, and accessibility have been reviewed where affected.
- `Package.swift`, bundle metadata, Xcode/Swift requirements, commands, and documentation agree.
- No build output, generated project, secret, certificate, or profile is committed.
- Private dSYMs remain outside Git and public distribution archives.
- `./scripts/check-skills.sh` passes.
- `NOTICE.md` records any new implementation or substantial guidance source.
