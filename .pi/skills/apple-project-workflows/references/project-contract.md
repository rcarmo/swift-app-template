# SwiftPM application contract

## Sources of truth

- `Package.swift`: products, targets, dependencies, deployment version, language mode, tests.
- `Sources/AppCore`: reusable application library.
- `Sources/Application`: executable `@main` scene.
- `Resources/Info.plist`: bundle metadata template, including the macOS minimum version.
- `Config/Starter.entitlements`: sandbox and capabilities.
- `scripts/build-macos-app.sh`: deterministic `.app` assembly and local signing.
- `Makefile`: public command interface.

There is no generated project. SwiftPM 6.2 compilation must remain usable without a package-manager bootstrap or an IDE. `Package.swift` and `Info.plist` both target macOS 26. Every target preserves MainActor default isolation, `InferIsolatedConformances`, `NonisolatedNonsendingByDefault`, and Swift 6 language mode.

## Adding package code

Put reusable behaviour in the narrowest `AppCore` feature/domain/infrastructure location. Add external packages only in `Package.swift`, pin according to project policy, and explain why Apple APIs or a small local implementation are insufficient.

## App bundle assembly

The bundler must:

1. build the named SwiftPM executable product;
2. create `Contents/MacOS` and `Contents/Resources`;
3. copy the executable under the app name;
4. substitute the application name, bundle identifier, marketing version, and build number into `Info.plist`;
5. copy SwiftPM resource bundles and optional `AppIcon.icns`;
6. for release builds, preserve a private UUID-matched dSYM and remove debug/local/nlist symbol data from the copied executable;
7. install `PkgInfo` and sign the complete bundle with entitlements;
8. verify hardening, the signature, and the plist.

## Rename and icon helpers

The one-shot rename updates package/product names, app entry filename, entitlements filename/path, bundle IDs, metadata, Make variables, scripts, workflows, docs, and local skill examples. Validate it in a disposable copy and reject stale placeholder references.

The icon helper accepts a 1024-square source and generates `build/AppIcon.icns`. Platform-specific asset catalogs can be introduced only with an actual future platform application.

## Workflow tests

`make workflow-test` uses temporary stubs to prove package build/test/lint commands are wired, SwiftPM build failures propagate, and the Make release plan passes the required optimisation/dead-strip flags plus hardening verification. It also proves these routes do not invoke Xcode project tooling or a package-manager bootstrap. This is orchestration evidence, not compilation.

## Continuous integration

GitHub Actions are permanently disabled in this template. `.github/workflows/` contains `.disabled` examples only, and static validation rejects active `.yml` or `.yaml` files. A derived repository may copy and review an example deliberately, but changes to this template must not activate CI, release, or scheduled workflows.

## Future iPadOS work

Add a thin iPadOS application consuming `AppCore` only when that phase starts. Keep shared architecture in SwiftPM and isolate bundle, provisioning, and platform composition at the new application boundary.
