# SwiftUI performance playbook

## Rendering and invalidation

- Keep observed state close to views that need it; broad environment reads can invalidate large subtrees.
- Split expensive regions into dedicated views with stable inputs.
- Keep `body` pure and cheap; move I/O and non-trivial preparation to models/services or cancellable tasks.
- Preserve structural identity for stateful/platform-backed views; modifier-value changes can be cheaper and safer than branch replacement.
- Avoid broad animation transactions and unscoped animation.

## Collections and layout

- Use stable IDs, not indices or generated values.
- Precompute/filter/sort outside repeated `List`/`ForEach` expressions when profiling shows cost; do not store stale derived state casually.
- Use lazy stacks for large scroll content.
- Prefer native `List`/`Table` virtualization where their semantics fit.
- Avoid `GeometryReader` chains, infinite frames combined with surprising layout priorities, and unnecessary fixed sizing.
- Keep hover actions mounted to avoid row reflow.

## Time and asynchronous work

- Prefer `.task`/`.task(id:)` for view-lifetime work and cancellation.
- Debounce/search with structured concurrency and cancel obsolete requests.
- Scope `TimelineView` to the leaf showing time and select the coarsest useful cadence.
- Prevent duplicate loads on repeated appearance and stale responses from committing.

## Images and resources

- Decode/resize images near display size off the main actor using appropriate system APIs.
- Bound caches by cost/count and respond to memory pressure.
- Avoid repeatedly constructing large gradients, paths, attributed strings, or formatters in hot bodies.
- Confirm copied SwiftPM resource bundles and optional application resources do not inflate the final `.app` unnecessarily.

## Startup and energy

Keep app initializers and first scene light. Defer optional work, parallelize independent structured operations carefully, and avoid launch-time permission prompts/network fan-out. Profile release builds; debug timing is misleading. Check wakeups, timers, network retries, location frequency, animations, and background work for energy impact.

## Measurement

Record Mac model, macOS version, window state, build configuration, data size, scenario, tool, duration, and metric. Run multiple samples and report variance. A microbenchmark that does not represent SwiftUI invalidation or layout can mislead; pair it with a trace of the real workflow.
