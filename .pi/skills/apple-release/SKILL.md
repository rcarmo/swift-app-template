---
name: apple-release
description: Prepare, validate, sign, notarise, package, and report this macOS application's direct Developer ID release without exposing credentials or claiming checks that were not run.
license: MIT
metadata:
  version: "3.0"
  provenance: Independently reimplemented from high-level tqbf/swiftui-app release ideas and Apple tool contracts; see NOTICE.md.
---

# macOS release

Read `docs/RELEASE.md`, `VERSION`, `Package.swift`, `Makefile`, bundle/release scripts, disabled workflow examples, and `references/release-checklist.md`. Load `../apple-project-workflows/SKILL.md` when configuration changes.

## Preflight

1. Confirm that direct Developer ID distribution is the requested channel; this repository does not implement App Store or TestFlight delivery.
2. Confirm product and bundle IDs, `VERSION`, build number policy, macOS minimum, category, icon, privacy metadata, and entitlements.
3. For GitHub release, require a semantic `v…` tag whose text after `v` exactly matches `VERSION`.
4. Run clean validation, lint, SwiftPM tests, release compilation, and real app-bundle assembly on macOS.
5. Inspect the signed product's nested code, entitlements, plist, architecture, and signature identity.
6. Keep certificates, passwords, API keys, profiles, and keychains outside Git and logs.

## Direct release

- Build the SwiftPM executable in release mode and assemble the `.app`.
- Preserve a private UUID-matched dSYM, strip debug/local/Swift nlist symbols from the distributed executable, and verify the result before signing.
- Sign the complete bundle with hardened runtime, a secure timestamp, and a Developer ID Application identity.
- Verify the signature before notarisation.
- Create a temporary zip, submit with `notarytool`, wait for acceptance, then staple and validate.
- Run Gatekeeper assessment.
- Create a new distribution zip only after stapling; write and verify its checksum.
- Extract and launch the final archive on another Mac outside the build tree.

Treat stripping and symbol redaction as cost-raising measures, not a secrecy boundary. Do not remove Swift reflection/runtime metadata blindly, publish the private dSYM, embed credentials, or move authoritative security decisions into the client.

Local setup stores an Apple ID notary profile through `make notary-setup`. The disabled GitHub Actions example creates an ephemeral profile from App Store Connect API-key secrets. Do not describe the two credential routes as interchangeable or imply that the example is active.

## Reporting

Report the source tag/commit, artifact path, version/build, identity class, notarisation submission/result, staple and Gatekeeper results, checksum, tested macOS/hardware, and commands run. If host capabilities or credentials are unavailable, list the unverified steps and stop. Never fabricate a release result.
