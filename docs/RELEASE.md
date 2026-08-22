# macOS release runbook

The supplied direct-distribution path builds the SwiftPM executable, assembles a macOS `.app`, signs the complete bundle with hardened runtime, notarises it, staples the ticket, passes Gatekeeper assessment, and creates a checksummed zip. It does not use an Xcode project or `xcodebuild`.

## Version contract

`VERSION` is the source marketing version. It must start with semantic `X.Y.Z`; prerelease suffixes such as `-rc.1` are accepted.

The disabled release-workflow example accepts a pushed tag or a manually supplied existing tag. The tag must start with `v`, match the semantic-version pattern, and equal `v` followed by the exact contents of `VERSION`. For example, `VERSION` `1.2.3` requires tag `v1.2.3`. Update and commit `VERSION` before creating the tag.

`BUILD_NUMBER` supplies `CFBundleVersion` for local or scripted bundle assembly. When omitted, the bundler uses a UTC timestamp. A derived application may impose a stricter monotonically increasing build-number policy.

## Prerequisites

- macOS 26 with Swift 6.2, normally from Xcode 26, and Apple command-line utilities.
- Apple Developer Program membership.
- A `Developer ID Application` certificate in the signing keychain.
- Notarisation credentials: a local Apple ID app-specific-password profile or an App Store Connect API key for GitHub Actions.
- Correct `Resources/Info.plist`, bundle identifier, entitlements, version, icon, and required privacy usage descriptions.

Inspect signing identities:

```sh
security find-identity -v -p codesigning
```

### Local notarisation credentials

Store an Apple ID app-specific password in a named Keychain profile without putting it on the command line:

```sh
APPLE_ID=you@example.com \
TEAM_ID=XXXXXXXXXX \
NOTARY_PROFILE=starter-notary \
make notary-setup
```

`notarytool` prompts for the app-specific password. The release command then refers only to the Keychain profile name.

### Disabled GitHub Actions example

GitHub Actions are permanently disabled in this template. `.github/workflows/release.yml.disabled` is reference material that uses an App Store Connect API key rather than the local Apple ID profile. A derived repository that deliberately activates and reviews it needs these secrets:

- `CERTIFICATE_P12_BASE64`
- `CERTIFICATE_PASSWORD`
- `CERT_NAME`
- `APP_STORE_CONNECT_API_KEY_BASE64`
- `APP_STORE_CONNECT_KEY_ID`
- `APP_STORE_CONNECT_ISSUER_ID`

The workflow creates an ephemeral signing keychain and `ci-notary` profile on the hosted runner. Use narrowly scoped credentials and rotate them.

## Direct local release

```sh
CERT_NAME='Developer ID Application: Your Name (XXXXXXXXXX)' \
NOTARY_PROFILE=starter-notary \
make dist VERSION="$(cat VERSION)"
```

`make release-check` always uses the release configuration. `make dist` runs it first: repository and skill validation, mocked workflow tests, strict formatting/linting, Swift Testing, and release-configuration executable compilation. Distribution therefore requires SwiftFormat and SwiftLint on `PATH` in addition to the signing and notarisation prerequisites.

The release script:

1. removes previous `build` and `dist` output;
2. compiles the executable product in release mode;
3. creates `build/Starter.app`, substitutes bundle identity/version/build metadata, copies SwiftPM resource bundles and an optional icon, and signs it;
4. re-signs the complete app with hardened runtime and a secure timestamp;
5. verifies the signature and creates a temporary notarisation zip;
6. submits with `notarytool --wait`, staples and validates the ticket, and runs `spctl --assess`;
7. creates `dist/Starter-<version>-macos.zip`, writes and verifies its SHA-256 file, and removes the temporary archive.

The final distribution archive is created only after stapling. The checksum contains the archive basename, so downloaded `.zip` and `.sha256` assets can be verified in any directory:

```sh
shasum -a 256 -c Starter-1.0.0-macos.zip.sha256
```

Before publishing, extract the final zip on another Mac, launch it outside the build tree, confirm Gatekeeper acceptance, exercise permissions and sandbox behaviour, and inspect the version and icon.

## GitHub release example

`.github/workflows/release.yml.disabled` shows a `v*` tag/manual-dispatch release on a macOS runner. It is not executable while the `.disabled` suffix remains. A derived repository must review its runner, Xcode selection, credentials, permissions, and triggers before copying it to an active workflow name.

The example uploads with `--clobber` when a GitHub release already exists. Treat published versions as immutable in normal operation; use replacement only to recover deliberately from a failed or partial workflow.

## Mac App Store distinction

This repository does not implement Mac App Store delivery. Store submission requires provisioning, store signing and export, App Store Connect metadata, privacy declarations, and review. Add and document a separate path if the product needs it.
