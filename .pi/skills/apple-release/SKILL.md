---
name: apple-release
description: Prepare, validate, sign, notarize, package, and report native Apple releases without exposing credentials or claiming checks that were not run.
license: MIT
metadata:
  version: "2.0"
  provenance: Independently reimplemented from high-level tqbf/swiftui-app release ideas and Apple tool contracts; see NOTICE.md.
---

# Apple release

Read `docs/RELEASE.md`, `Package.swift`, `Makefile`, bundle/release scripts, workflows, and `references/release-checklist.md`. Load `../apple-project-workflows/SKILL.md` for project changes.

## Preflight

1. Identify channel: local development, TestFlight/App Store, or direct Developer ID macOS distribution.
2. Confirm product/bundle IDs, version/build, minimum systems, category, icon assets, privacy declarations, entitlements, provisioning, export compliance, and update mechanism.
3. Run clean format/lint/tests, SwiftPM release compilation, and real app-bundle assembly on macOS.
4. Inspect the signed product's nested code, entitlements, metadata, and architecture.
5. Keep certificates, passwords, API keys, provisioning profiles, and keychains outside Git.

## Developer ID macOS release

- Build the SwiftPM executable in release mode, assemble the `.app`, then sign the complete bundle with hardened runtime and a Developer ID Application identity.
- Verify nested code and the app before notarisation.
- Zip for notarisation, submit with `notarytool`, wait for accepted status, staple and validate.
- Run Gatekeeper assessment.
- Create the distribution zip after stapling and write/verify its checksum.
- Extract and launch on another Mac outside the build tree.

## Reporting

Report artifact path, version/build, identity class, notarisation ID/result, staple and Gatekeeper result, checksum, tested OS/hardware, and commands run. If the host/credentials are unavailable, stop and enumerate unverified steps—never fabricate a release.
