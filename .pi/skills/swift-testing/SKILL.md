---
name: swift-testing
description: Design, write, or review deterministic Swift Testing coverage for domain logic, observable models, asynchronous dependencies, regressions, and cross-platform features.
license: MIT
metadata:
  version: "1.0"
  provenance: Adapted from twostraws hygiene/view guidance, Airbnb testing guidance, and this template's test strategy; see NOTICE.md.
---

# Swift Testing

Read `docs/TESTING.md` and `references/testing-patterns.md`. Use before implementation to identify test seams and after implementation to prove behavior.

## Workflow

1. Translate requirements into observable behavior and invariants.
2. Test pure domain logic first.
3. Inject deterministic service fakes into observable models.
4. Cover initial/loading/success/empty/failure/retry/cancellation and stale-response behavior as relevant.
5. Use fixed IDs, dates, locales, calendars, time zones, and clocks.
6. Add integration tests for persistence/network adapters with isolated resources.
7. Add UI tests only for critical journeys or behavior unavailable below UI level.
8. Run package tests and affected platform builds; manually validate layout/accessibility.

## Guardrails

- Use Swift Testing for new tests unless a required framework API needs XCTest.
- No force unwrap/force try in tests; failures should explain the missing precondition.
- No sleeps or dependence on wall-clock timing.
- No shared mutable fixture state between tests.
- Do not test private implementation details, SwiftUI body shape, or exact incidental call counts.
- A passing test suite is not proof that navigation, layout, focus, animation, signing, or permissions work.

## Output

List behavior covered, fixtures/dependencies, deterministic controls, commands run, and remaining manual/platform checks. For a regression, include a test that fails without the fix.
