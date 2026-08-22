# Testing and validation

## Test pyramid

1. **Pure unit tests** cover domain transformations, validation, sorting, and formatting.
2. **Model tests** inject deterministic services and verify loading, failure, cancellation, and mutation.
3. **Integration tests** verify real adapters behind temporary stores or controlled services.
4. **UI tests and manual checks** cover critical journeys, visual behavior, permissions, and installed application behavior.

Tests use Swift Testing. Keep identifiers, dates, clocks, and service results deterministic; never use sleeps to synchronize asynchronous tests.

## Local gates

```sh
make validate       # repository, script, resource, and skill checks
make workflow-test  # mocked Make orchestration
make lint           # optional SwiftFormat + SwiftLint gate
make test           # SwiftPM AppCore tests
make package-build  # SwiftPM executable compilation
make build          # assemble and sign a real macOS .app
```

`make build` and launch validation require macOS. `make workflow-test` proves command wiring only.

## Feature test checklist

Cover initial, loading, loaded, empty, filtered-empty, failure, retry, and cancellation states; duplicate and invalid input; dependency error presentation; selection preservation; stale asynchronous responses; user-facing formatting; and accessibility labels/actions for custom composition.

## Manual macOS acceptance

| Area | What to verify |
|---|---|
| Window | resize, restoration, minimum useful content, multiple windows if supported |
| Commands | menus, keyboard shortcuts, focus, Settings, open/save and drag/drop behavior |
| Appearance | light/dark, increased contrast, readable measure, semantic materials |
| Accessibility | VoiceOver, Voice Control, keyboard navigation, Reduce Motion, no color-only meaning |
| Lifecycle | relaunch, interruption, offline transitions, permission changes |
| Distribution | launch outside the build tree, signing identity, Gatekeeper, version and icon |

## CI

Continuous integration is intentionally disabled until a repository opts in. The preserved `.github/workflows/ci.yml.disabled` runs repository checks and SwiftPM build/tests on macOS; rename it to `ci.yml` and enable it in GitHub Actions when wanted.
