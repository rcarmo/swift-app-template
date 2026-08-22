# Current SwiftUI and Swift APIs

Check each API against the macOS deployment target in `Package.swift`. Add an availability guard or raise the deployment target when an API is newer.

## Prefer

- `foregroundStyle` over `foregroundColor`.
- `clipShape(.rect(cornerRadius:))` over `cornerRadius`.
- zero- or two-argument `onChange`; avoid the legacy single-value form.
- trailing `overlay(alignment:content:)` closures over legacy overloads.
- `scrollIndicators(.hidden)` over initializer flags.
- `sensoryFeedback` over custom AppKit haptic bridges where supported; Mac hardware support varies.
- `@Entry` for custom environment, focus, transaction, or container keys where available.
- generated asset accessors only when the package or application target enables them.
- `ImageRenderer` for rendering SwiftUI content.
- `#Preview` for previews.
- format styles and parse strategies over `String(format:)` and handwritten display-date formats.
- Swift-native string and URL APIs such as `replacing(_:with:)`, `URL.documentsDirectory`, and `appending(path:)`.
- `Date.now`, optional-binding shorthand, switch/if expressions, and omitted `return` in single expressions.
- `localizedStandardContains` for user-facing search.

## Avoid

- `NavigationView`, unguarded newer APIs, or assuming the installed SDK equals the minimum target.
- fixed screen bounds; use layout proposals, container-relative frames, `Layout`, or a narrowly justified `GeometryReader`.
- text concatenation with `+`; use interpolation or composed views so localisation can reorder content.
- unnecessary `NSColor` bridging in SwiftUI.
- `ObservableObject` for new state when Observation fits. Import Combine explicitly when legacy interoperability requires it.
- C-style formatting, force unwraps, force tries, or logging user-action errors without presenting them.
- manual plural rules where String Catalog variation or grammar agreement applies.

## Availability review

For each new API:

1. Check every target that compiles the file.
2. Compare the SDK introduction with each target's deployment version.
3. Use `#if os(...)` only when a second platform target creates a real compile-time seam.
4. Use `if #available` when one source file needs a runtime fallback.
5. Add a test or manual check for the fallback.
