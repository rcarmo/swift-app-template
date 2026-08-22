---
name: swift-testing
description: Design, write, or review deterministic Swift Testing coverage for the macOS package's domain logic, observable models, asynchronous dependencies, regressions, and adapters.
license: MIT
metadata:
  version: "2.0"
  provenance: Adapted from twostraws hygiene/view guidance, Airbnb testing guidance, and this template's test strategy; see NOTICE.md.
---

# Swift Testing

Read `docs/TESTING.md` and `references/testing-patterns.md`. Identify test seams before implementation and use tests afterward as one part of the evidence.

## Workflow

1. Translate requirements into observable behaviour and invariants.
2. Test pure domain logic first.
3. Inject deterministic service fakes into observable models.
4. Cover only applicable transitions: initial, loading, success, empty, failure, retry, cancellation, and stale response.
5. Fix IDs, dates, locales, calendars, time zones, and clocks.
6. Add isolated integration tests when persistence, network, filesystem, or Keychain adapters are introduced.
7. Add UI automation only for critical journeys or behaviour that cannot be verified below the UI.
8. Run `make test` and `make package-build`; assemble and manually exercise the macOS application for UI, focus, window, accessibility, entitlement, or bundle changes.

## Guardrails

- Use Swift Testing for new tests unless a required framework API needs XCTest.
- Avoid force unwraps and force tries in tests; use `#require` or throwing helpers with useful context.
- Do not sleep or depend on wall-clock timing.
- Do not share mutable fixture state between tests.
- Test behaviour rather than private implementation, SwiftUI body shape, or incidental call counts.
- A passing suite does not prove navigation, layout, focus, animation, signing, permissions, or bundle metadata.
- Do not claim generic checklist states as covered unless a test or recorded manual run verifies them.

## Output

List behaviour covered, fixtures and dependencies, deterministic controls, commands run, macOS assembly/manual checks, and remaining gaps. A regression fix should include a test that fails without the fix when practical.
