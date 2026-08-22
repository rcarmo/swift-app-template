---
name: swiftui-performance
description: Diagnose and improve SwiftUI rendering, invalidation, collection, scrolling, image, task, startup, memory, and energy performance using measurement rather than folklore.
license: MIT
metadata:
  version: "1.0"
  provenance: Adapted from twostraws performance guidance and project-specific SwiftUI profiling practice; see NOTICE.md.
---

# SwiftUI performance

Read `references/performance-playbook.md`. Use for slow rendering, scrolling hitches, repeated work, memory growth, startup delay, excessive body updates, battery/thermal issues, or performance-focused review.

## Workflow

1. Reproduce with a representative device, OS, data set, and build configuration.
2. Record a baseline metric or trace; do not optimize from code appearance alone.
3. Use Instruments (SwiftUI, Time Profiler, Allocations/Leaks, Core Animation, Network, Energy) and signposts where appropriate.
4. Identify the invalidation source, expensive transform, I/O boundary, allocation, layout cycle, image cost, or task storm.
5. Apply the smallest correction while preserving behavior and accessibility.
6. Re-measure under the same conditions and add a regression benchmark/test where stable.
7. Build/run the lowest supported and lowest-spec relevant target.

## Guardrails

- Do not add `EquatableView`, caches, manual memoization, or flattened view trees without evidence.
- Do not move work to a background task unless ownership, cancellation, actor isolation, and UI commit are correct.
- Avoid `AnyView`, unstable IDs, eager stacks for large data, expensive transforms in `body`, and formatter creation when format styles work.
- Scope timers/`TimelineView` and observation to the smallest subtree.
- Cache only with measured benefit and explicit invalidation/memory bounds.
- Performance changes must not remove labels, Dynamic Type, reduced-motion behavior, or platform semantics.

## Output

Report reproduction, baseline, trace/tool, root cause, change, after measurement, variance, tested hardware/OS, and remaining risks. Separate measured facts from hypotheses.
