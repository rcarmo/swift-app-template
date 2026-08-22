# Project and build contract

## One-shot and daily commands

```sh
make bootstrap      # fresh Mac: install tools, validate, test, generate, build macOS
make bootstrap-all  # fresh Mac: same, then build every configured target
make                # same as make build: validated default native macOS build
make build-all      # validated iOS/Catalyst/macOS/tvOS/visionOS/watchOS matrix
make validate       # portable static repository and local-skill checks
make doctor         # full Xcode selection/first-launch/toolchain preflight
make app-macos      # ad-hoc signed local bundle in build/
```

`make bootstrap` is idempotent through `brew bundle`; it must leave a generated project and successful default build. The Make dependency graph should execute shared validation, dependency resolution, and generation once per invocation rather than chaining redundant recursive targets. `make validate` checks structure, skills, shell syntax, whitespace, secret patterns, and JSON. It must work without Xcode and must not print a false compile success.

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

## Makefile orchestration tests

Run `make workflow-test` to test Make target wiring with temporary stub executables for `uname`, `xcodebuild`, `xcrun`, `brew`, `xcodegen`, `swift`, `swiftformat`, and `swiftlint`. It asserts `bootstrap` reaches validate/lint/test/resolve/macOS build, `bootstrap-all` invokes all six build destinations, and native build failures propagate. This proves orchestration only, not Swift compilation.

## CI

Linux performs portable checks. macOS installs tools, generates, lints, tests the package, and builds each platform including Catalyst. Pin or review action/tool changes and update generic destinations when runner Xcode versions change.
