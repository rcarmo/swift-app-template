---
name: swiftui-hardening
description: Reproduce and harden macOS SwiftUI runtime, layout, hosting, list/table, state-restoration, stale-cache, focus, and hover failures that unit tests do not catch.
license: MIT
metadata:
  version: "1.0"
  provenance: Independent project-specific synthesis informed by failure categories observed in tqbf/swiftui-app; no unlicensed source text/code copied; see NOTICE.md.
---

# SwiftUI hardening

Read `references/runtime-hardening.md`. Use for crashes, layout breakage, frozen/stale UI, hover/list defects, restoration surprises, hosting issues, or any “works in tests but fails live” report.

## Workflow

1. Reproduce on the exact macOS minor version, hardware class, window size/state, input method, and hosting context.
2. Reduce to the smallest view/state transition while preserving the failure.
3. Classify it: structural identity/transition, layout proposal/priority, observation/cache, list/table/scroll container, storage/restoration, focus/hover, or AppKit/SwiftUI hosting mismatch.
4. Replace brittle composition with the simplest system-native invariant.
5. Add a deterministic logic regression test where possible and a documented live-run scenario where not.
6. Run repeated state changes, window resize/full-screen/tile changes, navigation and modal cycles, appearance, accessibility, focus, and lowest-supported-macOS checks.
7. Record the failure mode and fix in a feature note if it is non-obvious.

## Guardrails

- A passing unit suite is not a passing app; live-run non-trivial view changes.
- Do not turn one observed framework bug into a universal rule without macOS-version and hosting evidence.
- Prefer stable view identity and dimensional/modifier changes when structural insertion/removal destabilizes hosted layouts.
- Rebuild snapshot-derived caches from the canonical source after mutations.
- Treat `@SceneStorage`/restoration defaults as persisted user state requiring migration.
- Hover-only actions must not reflow rows and need keyboard/menu alternatives.

## Output

Report the macOS/hardware/window/input matrix, minimal trigger, classification, evidence, fix, regression protection, live-run results, and uncertainty about OS-specific behaviour.
