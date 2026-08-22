---
name: apple-project-workflows
description: Maintain the Swift package, XcodeGen project, Make targets, platform build matrix, rename/icon helpers, CI, signing capabilities, and generated-file contract.
license: MIT
metadata:
  version: "1.0"
  provenance: Independently reimplemented from high-level tqbf/swiftui-app workflow ideas plus this template's XcodeGen design; see NOTICE.md.
---

# Apple project workflows

Read `Package.swift`, `project.yml`, `Makefile`, `Brewfile`, `.github/workflows/`, and `references/project-contract.md`. Use for targets, dependencies, deployment versions, entitlements, generated projects, build scripts, rename/icon changes, or CI.

## Source-of-truth contract

- `Package.swift` defines the reusable/testable `AppCore` library and package tests.
- `project.yml` defines native app targets, schemes, bundle IDs, settings, resources, entitlements, and local package consumption.
- `Starter.xcodeproj` is generated, ignored, and never edited or committed.
- `Makefile` is the documented front door.
- `Brewfile` names development tools.
- `.github/workflows` reproduce validation on clean runners.

## Workflow

1. Identify which source of truth owns the requested change.
2. Preserve distinct bundle identities for native macOS, Catalyst, and other products.
3. Edit configuration, regenerate, inspect generated settings/schemes, and build affected targets.
4. Keep shared AppCore tests runnable with `swift test` independently of Xcode generation.
5. Update rename/icon/static-check scripts when adding a name, path, target, asset, or required file.
6. Run a rename simulation in a disposable copy after template-identity changes.
7. Update README/AGENTS/docs and CI together.

## Guardrails

- Never hand-edit generated project files.
- Do not claim SwiftPM creates installable iOS/watchOS/tvOS/visionOS apps; Xcode app targets do.
- Do not make Linux static validation claim native compilation.
- Do not commit DerivedData, generated projects, profiles, certificates, keychains, or secrets.
- Keep shell scripts compatible with macOS system Bash unless explicitly requiring a newer shell.
- Entitlements are minimal by default; each added capability needs product justification and a denied/restricted path.

## Output

List changed sources of truth, regenerated files (if any), target/scheme effects, commands run, and macOS/Xcode checks not available.
