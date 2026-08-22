# Modern SwiftUI and Swift API

Apply availability against this repository's declared minimum OS versions; do not recommend a newer API without an availability guard or deployment-target change.

## Prefer

- `foregroundStyle` over `foregroundColor`.
- `clipShape(.rect(cornerRadius:))` over `cornerRadius`.
- the modern `Tab` API over `tabItem` when available at all selected targets.
- zero- or two-argument `onChange`; avoid the legacy single-value form.
- `overlay(alignment:content:)` trailing closures over legacy overlay overloads.
- `.topBarLeading`/`.topBarTrailing` rather than deprecated navigation-bar placements.
- `scrollIndicators(.hidden)` rather than initializer flags.
- `sensoryFeedback` instead of UIKit haptic generators where supported.
- `@Entry` for custom environment/focus/transaction/container keys when available.
- generated asset symbols where the Xcode project enables them.
- `ImageRenderer` for rendering SwiftUI content.
- `#Preview` for previews.
- format styles and parse strategies rather than `String(format:)` and hand-written display-date formats.
- Swift-native string and URL APIs such as `replacing(_:with:)`, `URL.documentsDirectory`, and `appending(path:)`.
- `Date.now`, optional-binding shorthand, switch/if expressions, and omitted `return` for single expressions.
- `localizedStandardContains` for user-facing search.

## Avoid

- `NavigationView`, unguarded platform-only APIs, or assuming the newest SDK equals the minimum target.
- `UIScreen.main.bounds`; use layout proposals, container-relative frames, `Layout`, or a narrowly justified `GeometryReader`.
- text concatenation with `+`; use interpolation or composed views so localization can reorder content.
- unnecessary `UIColor`/`NSColor` in SwiftUI.
- `ObservableObject` for new state when Observation fits. If legacy Combine integration requires it, import Combine explicitly.
- C-style formatting, force unwraps, force tries, and errors logged instead of presented after user actions.
- manual plural rules where String Catalog pluralization or automatic grammar agreement applies.

## Availability review

For each new API:

1. Check all platforms that compile the file.
2. Compare SDK introduction with every deployment target.
3. Use `#if os(...)` only for actual platform seams.
4. Use `if #available` when one source file needs a runtime fallback.
5. Add a test or manual matrix entry for the fallback.
