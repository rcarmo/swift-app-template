---
name: apple-project-workflows
description: Maintain the Swift package, Make targets, macOS app bundle assembly, rename/icon helpers, disabled CI examples and policy, signing capabilities, and build-source contract.
license: MIT
metadata:
  version: "2.0"
  provenance: Independently adapted from rcarmo/EditorBridge's MIT-licensed SwiftPM app topology and high-level tqbf/swiftui-app ideas; see NOTICE.md.
---

# Apple project workflows

Read `Package.swift`, `Makefile`, `.github/workflows/`, scripts, and `references/project-contract.md`. Use for targets, dependencies, deployment versions, bundle metadata, entitlements, build scripts, rename/icon changes, or CI policy.

## Source-of-truth contract

- `Package.swift` defines the `AppCore` library, `Starter` executable, deployment version, and tests.
- `Resources/Info.plist` and `Config/Starter.entitlements` define macOS bundle metadata and capabilities.
- `scripts/build-macos-app.sh` assembles and signs the SwiftPM executable as a macOS `.app`; release mode also preserves private symbols, strips the copied Mach-O, and verifies hardening.
- `Makefile` is the documented front door.
- No Xcode project, XcodeGen, `xcodebuild`, or package-manager bootstrap is part of the build contract.

## Workflow

1. Identify which source of truth owns the requested change.
2. Keep reusable code in `AppCore` and scene/process ownership in the executable target.
3. Build/test with SwiftPM before assembling the app bundle.
4. Update metadata, entitlements, rename/icon/static-check scripts together.
5. Run a rename simulation in a disposable copy after template-identity changes.
6. Update README, AGENTS, docs, skills, and workflows together.
7. Run `make validate`, `make workflow-test`, SwiftPM tests/build, macOS bundle assembly, and `make hardening-check` as the host permits; distinguish their evidence.

## Guardrails

- Do not add an Xcode project or a speculative iPadOS target before that product phase exists.
- Do not commit build output, profiles, certificates, keychains, or secrets.
- Keep scripts compatible with macOS system Bash.
- Sign the complete `.app`; permissions/TCC attach to bundle identity rather than the raw SwiftPM executable.
- Entitlements are minimal by default; each capability needs product justification and a denied/restricted path.
- GitHub Actions remain permanently disabled in this template; keep every workflow example suffixed `.disabled` and reject active `.yml`/`.yaml` files.
- Report SwiftPM compilation, app assembly, launch, signing, and notarisation as distinct checks.
