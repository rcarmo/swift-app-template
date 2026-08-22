# macOS release runbook

The release path builds the generated native macOS target with Xcode, signs it with hardened runtime, submits a temporary zip to Apple, staples the ticket, creates a fresh distribution zip, and writes its SHA-256 checksum.

## Prerequisites

- macOS with current Xcode command-line tools.
- Membership in the Apple Developer Program.
- A `Developer ID Application` certificate in the signing keychain.
- An App Store Connect team and notarisation credential.
- Correct bundle identifier, entitlements, privacy usage descriptions, version, icon, and product name.

Inspect identities:

```sh
security find-identity -v -p codesigning
```

Store credentials interactively; the app-specific password is read by `notarytool` and must not appear in shell history:

```sh
APPLE_ID=you@example.com \
TEAM_ID=XXXXXXXXXX \
NOTARY_PROFILE=starter-notary \
make notary-setup
```

## Build and verify

```sh
CERT_NAME='Developer ID Application: Your Name (XXXXXXXXXX)' \
TEAM_ID=XXXXXXXXXX \
NOTARY_PROFILE=starter-notary \
make dist VERSION=1.0.0
```

The script performs `codesign --verify`, `stapler validate`, and `spctl --assess`. Before publishing, also:

1. Extract the final zip on another Mac.
2. Confirm Gatekeeper accepts it and the app launches from outside the build tree.
3. Exercise network, file, keychain, notification, and sandbox permissions.
4. Confirm version/build metadata and icon.
5. Verify the checksum:

   ```sh
   shasum -a 256 -c dist/Starter-1.0.0-macos.zip.sha256
   ```

## GitHub Actions secrets

The optional release workflow expects:

- `CERTIFICATE_P12_BASE64`
- `CERTIFICATE_PASSWORD`
- `CERT_NAME`
- `TEAM_ID`
- `APP_STORE_CONNECT_API_KEY_BASE64`
- `APP_STORE_CONNECT_KEY_ID`
- `APP_STORE_CONNECT_ISSUER_ID`

Use a narrowly scoped App Store Connect key and rotate credentials. GitHub-hosted runner keychains are ephemeral.

## App Store distribution

The supplied `make dist` path is for direct Developer ID distribution. App Store submissions require an App Store provisioning/signing setup, archive/export configuration, store metadata, privacy declarations, and review. Configure those explicitly in the generated Xcode project source (`project.yml`) or a dedicated release configuration; do not reuse Developer ID assumptions blindly.
