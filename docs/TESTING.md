# Testing and validation

## Automated layers

1. **Swift Testing unit/model tests** cover `ItemSearch` query behaviour plus `AppModel` initial loading, visible failure mapping, initial selection, and favourite mutation.
2. **Static validation** checks the SwiftPM-only repository shape, required files and Make targets, shell syntax, local skills, whitespace, common committed-secret forms, and plist/JSON syntax when host tools are available.
3. **Workflow tests** use stub executables to verify Make command wiring and failure propagation without compiling Swift.
4. **SwiftPM compilation** builds the executable product and catches type, availability, and strict-concurrency failures for the current macOS package.
5. **Assembled-app validation** on macOS covers bundle creation, plist substitution, resources, entitlements, and code signing.
6. **Manual acceptance** covers runtime interaction, accessibility, window behaviour, permissions, and distribution on a real Mac.

The starter does not contain UI automation, snapshot tests, persistence/network integration tests, release-credential tests, or exhaustive cancellation/stale-response coverage. Add those when product behaviour requires them.

Tests use Swift Testing. Keep identifiers, dates, clocks, locales, and service results deterministic; do not use sleeps to synchronise asynchronous tests.

## Local gates

```sh
make validate       # repository, script, resource, and skill checks
make workflow-test  # mocked Make orchestration; no Swift compilation
make lint           # optional SwiftFormat and SwiftLint gate
make test           # AppCoreTests through SwiftPM
make package-build  # compile the Starter product through SwiftPM
make build          # assemble and sign a real macOS .app
```

`make build` and launch acceptance require macOS. The default local signature is ad hoc. A successful `make workflow-test` proves only that Make invokes the expected commands.

`make check` combines validation, lint, tests, and executable compilation. It does not assemble or launch the application.

## Feature checklist

Add coverage for the states and risks introduced by the feature: initial, loading, loaded, empty, filtered-empty, failure, retry, cancellation, overlapping requests, invalid input, selection changes, dependency error presentation, user-facing formatting, and accessibility actions. Do not claim a state is covered merely because it appears in a generic checklist.

## Manual macOS acceptance

| Area | Verify |
|---|---|
| Window | narrow/wide/full-screen resize, restoration, minimum useful content, additional windows if supported |
| Commands | menus, shortcuts, focus order, Settings, open/save, context menus, and drag/drop alternatives |
| Pointer and keyboard | selection, hover, Full Keyboard Access, deletion, Return/Escape behaviour |
| Appearance | light/dark, active/inactive, Increase Contrast, Reduce Transparency, readable measure |
| Accessibility | VoiceOver, Voice Control, text scaling, Reduce Motion, Differentiate Without Color |
| Lifecycle | relaunch, interruption, offline transitions, permission denial/revocation |
| Distribution | launch outside the build tree, signature identity, Gatekeeper, version, build number, and icon |

Record the macOS version, hardware, window state, input device, and checks performed.

## Continuous integration

Continuous integration is opt-in. The preserved `.github/workflows/ci.yml.disabled` runs validation, workflow tests, SwiftPM tests/build, and macOS app assembly on `macos-15`. Rename it to `.github/workflows/ci.yml`, review the triggers and action versions, and enable GitHub Actions when the derived repository is ready. Do not keep both active and disabled copies.

The release and action-artifact-pruning workflows are already active; disabling CI does not disable them.
