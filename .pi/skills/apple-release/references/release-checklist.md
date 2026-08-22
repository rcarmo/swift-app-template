# Apple release checklist

## Product metadata

- Marketing version and monotonically increasing build number.
- Correct product name and distinct bundle identifiers.
- Deployment target and supported architectures.
- Complete platform-specific icon assets.
- Usage descriptions, privacy manifests/declarations, export compliance, and store metadata.
- Minimal entitlements matching actual features.

## Quality gate

- Clean checkout/generation.
- Formatter and strict linter pass.
- Unit/integration/UI tests as applicable.
- Every affected platform compiles with release settings.
- Accessibility and localization matrix reviewed.
- Offline, denied permission, migration, update, and first-launch behavior checked.

## Signing safety

Use keychain profiles/environment references; never echo secrets. Confirm identity with `security find-identity`. Inspect:

```sh
codesign --verify --deep --strict --verbose=2 App.app
codesign -d --entitlements :- App.app
```

Treat `--deep` as verification convenience, not a substitute for correctly signing nested code in dependency order.

## Notarisation order

1. build/sign app;
2. verify signature;
3. create temporary notarisation archive;
4. submit/wait and inspect failure log if rejected;
5. staple app;
6. validate staple and `spctl --assess`;
7. create fresh distribution archive;
8. checksum and test extraction/launch.

## App Store distinction

Developer ID distribution is not App Store distribution. Store delivery needs distribution profiles/certificates, archive/export settings, App Store Connect records, screenshots/metadata, privacy declarations, TestFlight validation, and review. Do not reuse direct-release assumptions blindly.

## Rollback and provenance

Tag source, record Xcode/tool versions, retain checksums and notarisation metadata, and know how to withdraw or supersede a broken release. Never overwrite an existing versioned artifact silently.
