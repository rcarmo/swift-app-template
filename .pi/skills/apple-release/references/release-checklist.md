# Direct macOS release checklist

## Source and version

- `VERSION` starts with semantic `X.Y.Z` and contains no surrounding whitespace.
- Release tag is `v` followed by the exact `VERSION` value.
- The tag resolves to the intended commit.
- `BUILD_NUMBER` policy is explicit; the bundler otherwise uses a UTC timestamp.
- Product name, executable product, app name, bundle identifier, entitlements path, and output names agree.
- `Package.swift` and `Resources/Info.plist` both require macOS 26; the build uses Swift 6.2/Xcode 26.

## Product metadata

- Correct category and optional icon.
- Required usage descriptions and privacy declarations match code and dependencies.
- Entitlements are minimal and match actual capabilities.
- Optional update and rollback mechanisms are documented by the derived application.

## Quality evidence

- `make validate` and `make workflow-test` pass.
- SwiftFormat/SwiftLint pass when installed.
- SwiftPM tests and release executable compilation pass.
- The real `.app` assembles on macOS; plist substitution, resources, executable, entitlements, and signature are inspected.
- Accessibility, localisation, denied-permission, offline, migration, update, and first-launch checks relevant to the product are recorded.

## Credential routes

- Local: `make notary-setup` stores an Apple ID app-specific password in a named `notarytool` Keychain profile.
- Disabled GitHub Actions example: repository secrets provide a base64 certificate and App Store Connect API key; an explicitly activated derived workflow would create an ephemeral keychain and `ci-notary` profile.
- Secrets are passed through environment or Keychain references and are never echoed, committed, or copied into release notes.

## Signing inspection

Confirm the identity with `security find-identity`, then inspect the assembled app:

```sh
codesign --verify --deep --strict --verbose=2 App.app
codesign -d --entitlements :- App.app
plutil -p App.app/Contents/Info.plist
```

`--deep` is a verification convenience, not a substitute for signing nested code in dependency order when the product gains frameworks, helpers, or extensions.

## Notarisation order

1. build and assemble the application;
2. sign with Developer ID, hardened runtime, and timestamp;
3. verify the signature;
4. create a temporary notarisation archive;
5. submit and wait; inspect the notary log if rejected;
6. staple and validate the application;
7. run `spctl --assess`;
8. create a fresh distribution archive;
9. write and verify the checksum;
10. extract and launch the final archive on another Mac.

## Scope and provenance

The supplied automation is for direct Developer ID distribution, not the Mac App Store or TestFlight. Store delivery needs a separate documented path.

Record the source tag/commit, Swift and macOS versions, artifact checksum, notarisation submission/result, and manual acceptance host. Do not silently replace a published versioned artifact in normal operation.
