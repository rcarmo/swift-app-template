# View composition and performance

## Composition

- Keep `body` declarative and cheap; assume SwiftUI reevaluates it frequently.
- Extract a substantial or reusable region into its own `View` type and file. A small private helper is acceptable when it is tightly coupled and would remain readable inline.
- Keep initializers free of I/O, parsing, sorting, image processing, and other non-trivial work.
- Extract button actions into named methods when they contain logic.
- Put business rules into pure domain functions or observable application state where they can be tested.
- Store built generic view content (`@ViewBuilder let content: Content`) rather than an escaping closure where possible.
- Avoid `AnyView`; use generics, `Group`, or `@ViewBuilder`.

## Identity and collections

- Give domain rows stable `Identifiable` IDs; never generate a new ID during rendering.
- Do not use array indices as identity for mutable collections.
- Prefer value-driven navigation with `Hashable` values.
- Avoid expensive inline `filter`, `sorted`, or mapping work inside `List`/`ForEach` when it repeats on every update.
- Derive data from the source of truth. Cache only with an explicit invalidation strategy.
- Use lazy stacks for large scroll collections.

## State and structural identity

- Prefer modifier-value changes to conditional replacement when preserving state or a platform view matters.
- For simple visual toggles, a ternary modifier value often preserves identity better than an `if` branch.
- Never insert/remove views merely to produce hover feedback on macOS; keep row layout stable and animate opacity/hit testing.
- Scope `TimelineView`, timers, and frequently changing state to the smallest leaf.
- Bind animations to a value. Do not use the unscoped `animation(_:)` form.
- Respect Reduce Motion; do not chain arbitrary sleeps to sequence animations.

## Text entry and formatting

- Prefer `TextField(axis: .vertical)` with a line range for short multi-line entry; use `TextEditor` for true document editing.
- Bind numeric fields to numeric values with a format style, then add the platform-appropriate keyboard type.
- Use semantic `Text` format styles for dates, numbers, currency, and measurement.

## Performance investigation

Do not optimize by superstition. Reproduce the issue, inspect body invalidations and Instruments, identify the expensive dependency or view boundary, make the smallest change, then measure again. A passing unit suite does not prove layout or runtime performance; run the affected UI on the lowest supported OS/device class.
