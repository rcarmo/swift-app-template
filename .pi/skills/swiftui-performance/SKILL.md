---
name: swiftui-performance
description: Diagnose and improve macOS SwiftUI rendering, invalidation, table/list, scrolling, image, task, startup, memory, and energy performance using measurement.
license: MIT
metadata:
  version: "1.0"
  provenance: Adapted from twostraws performance guidance and project-specific SwiftUI profiling practice; see NOTICE.md.
---

# SwiftUI performance

Read `references/performance-playbook.md`. Use for slow rendering, scrolling hitches, repeated work, memory growth, startup delay, excessive body updates, battery/thermal issues, or performance-focused review.

## Workflow

1. Reproduce with representative Mac hardware, macOS version, window configuration, data set, and release/debug build as appropriate.
2. Record a baseline metric or trace; do not optimise from code appearance alone.
3. Use Instruments (SwiftUI, Time Profiler, Allocations/Leaks, Core Animation, Network, Energy) and signposts where appropriate.
4. Identify the invalidation source, expensive transform, I/O boundary, allocation, layout cycle, image cost, or task storm.
5. Apply the smallest correction while preserving behaviour and accessibility.
6. Re-measure under the same conditions and add a regression benchmark/test where stable.
7. Build and run on macOS 26 and the lowest-spec supported Mac practical for the product.

## Guardrails

- Do not add `EquatableView`, caches, manual memoization, or flattened view trees without evidence.
- Do not move work to a background task unless ownership, cancellation, actor isolation, and UI commit are correct.
- Avoid `AnyView`, unstable IDs, eager stacks for large data, expensive transforms in `body`, and formatter creation when format styles work.
- Scope timers/`TimelineView` and observation to the smallest subtree.
- Cache only with measured benefit and explicit invalidation/memory bounds.
- Performance changes must not remove labels, text scaling, reduced-motion behaviour, keyboard/focus support, or native macOS semantics.

## Output

Report reproduction, baseline, trace/tool, root cause, change, after measurement, variance, tested hardware/macOS/window state, and remaining risks. Separate measured facts from hypotheses.
