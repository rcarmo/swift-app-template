# Project and build contract

## Daily commands

```sh
make validate       # portable static repository checks
make generate       # XcodeGen project
make format
make lint
make test           # SwiftPM AppCore tests
make build-ios
make build-macos
make build-tvos
make build-visionos
make build-watchos
make app-macos
```

`make validate` checks structure, shell syntax, whitespace, secret patterns, and JSON. It must work without Xcode and must not print a false compile success.

## Target changes

When adding a platform/extension/widget:

1. add deployment target and target/scheme to `project.yml`;
2. assign a distinct bundle identifier and correct product type;
3. define resources and app-extension embedding explicitly;
4. add minimal entitlements/capabilities;
5. add Make/CI build coverage;
6. adapt shared code at a clear platform seam;
7. document simulator/device/manual validation.

## Dependencies

Prefer Apple frameworks and a small local implementation. A package dependency requires purpose, licence, maintenance/security review, platform support, version strategy, and impact on app size/startup. Add it to `Package.swift` only when shared library code needs it; otherwise configure the owning Xcode target deliberately.

## Rename helper

The one-shot rename must update package/product names, schemes/targets, app entry filename, entitlements filename/path, bundle-ID family, Make variables, workflows, docs, and local skill examples while excluding itself, `.git`, and build output. Validate a disposable renamed copy and assert no old-name references except the helper's source constants.

## Icons and resources

The helper generates iOS and macOS assets from a 1024-square source. tvOS, watchOS, and visionOS may require platform-specific asset roles/artwork; configure them explicitly rather than implying one universal image satisfies all store requirements. Resource additions must be included by both the package or app target that owns them, not copied ad hoc.

## CI

Linux performs portable checks. macOS installs tools, generates, lints, tests the package, and builds each platform. Pin or review action/tool changes and update simulator destinations when runner Xcode versions change.
