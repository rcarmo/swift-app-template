---
name: apple-release
description: Prepare, validate, sign, notarize, and package this template's Apple builds without exposing credentials or claiming checks that were not run.
---

# Apple release

Read `docs/RELEASE.md`, `Makefile`, `project.yml`, and the release scripts before changing the pipeline.

## Preflight

1. Confirm product name, bundle identifiers, version/build numbers, minimum systems, icon, entitlements, privacy descriptions, and distribution channel.
2. Run formatting, lint, tests, and every affected platform build on macOS/Xcode.
3. Review archive contents and embedded frameworks for correct signing and entitlements.
4. Keep certificates, passwords, API keys, provisioning profiles, and keychains outside Git. Pass only environment variable or keychain profile names to scripts.

## Developer ID macOS release

- Use a `Developer ID Application` identity with hardened runtime.
- Build and sign the app before creating the notarisation zip.
- Submit with `notarytool`, wait for success, staple and validate the app.
- Create the distribution zip only after stapling.
- Run `codesign --verify`, `spctl --assess`, and checksum verification.
- Test the extracted artifact on another Mac.

## Reporting

List produced artifact paths, version, identity class, notarisation result, Gatekeeper result, checksum, and tests/builds run. If the host is not macOS or credentials are absent, stop and report the unverified steps; never fabricate a release result.
