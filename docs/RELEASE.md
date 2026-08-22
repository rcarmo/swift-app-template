# macOS release runbook

The direct-distribution path builds the SwiftPM executable, assembles a conventional macOS `.app`, signs the complete bundle with hardened runtime, notarises it, staples the ticket, and creates a checksummed distribution zip. It does not use an Xcode project or `xcodebuild`.

## Prerequisites

- macOS with a Swift 6 toolchain and Apple command-line utilities.
- Apple Developer Program membership.
- A `Developer ID Application` certificate in the signing keychain.
- App Store Connect notarisation credentials.
- Correct `Resources/Info.plist`, bundle identifier, entitlements, version, icon, and privacy usage descriptions.

Inspect identities:

```sh
security find-identity -v -p codesigning
```

Store credentials interactively:

```sh
APPLE_ID=you@example.com \
TEAM_ID=XXXXXXXXXX \
NOTARY_PROFILE=starter-notary \
make notary-setup
```

## Build and verify

```sh
CERT_NAME='Developer ID Application: Your Name (XXXXXXXXXX)' \
NOTARY_PROFILE=starter-notary \
make dist VERSION=1.0.0
```

The release path:

1. builds the `Starter` SwiftPM product in release mode;
2. creates `build/Starter.app` with metadata, resources, executable, and entitlements;
3. signs it with Developer ID and hardened runtime;
4. verifies the bundle and submits a temporary zip for notarisation;
5. staples and validates the ticket, then runs Gatekeeper assessment;
6. creates `dist/Starter-1.0.0-macos.zip` and its SHA-256 file.

Before publishing, extract the final zip on another Mac, confirm Gatekeeper acceptance, exercise permissions and sandbox behavior, inspect version/icon metadata, and verify:

```sh
cd dist
shasum -a 256 -c Starter-1.0.0-macos.zip.sha256
```

The checksum records only the archive basename, so the two downloaded GitHub release assets can also be verified together in any directory.

## GitHub Actions secrets

The optional tag/manual release workflow expects:

- `CERTIFICATE_P12_BASE64`
- `CERTIFICATE_PASSWORD`
- `CERT_NAME`
- `APP_STORE_CONNECT_API_KEY_BASE64`
- `APP_STORE_CONNECT_KEY_ID`
- `APP_STORE_CONNECT_ISSUER_ID`

Use narrowly scoped credentials and rotate them. Hosted-runner keychains are ephemeral.

## App Store distribution

The supplied path is for direct Developer ID distribution. Mac App Store submission requires provisioning, store signing/export, metadata, privacy declarations, and review. Add a dedicated distribution path if the product needs it; do not hide those requirements behind the direct-distribution script.
