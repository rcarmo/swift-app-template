# Current SwiftUI and Swift APIs

The package targets macOS 26 and Swift 6.2. Check each API against that contract and every target that compiles the file.

## Prefer

- `foregroundStyle` over `foregroundColor`.
- `clipShape(.rect(cornerRadius:))` over `cornerRadius`.
- zero- or two-argument `onChange`; avoid the legacy single-value form.
- trailing `overlay(alignment:content:)` closures over legacy overloads.
- `scrollIndicators(.hidden)` over initializer flags.
- `sensoryFeedback` over custom AppKit haptic bridges where supported; Mac hardware support varies.
- `@Entry` for custom environment, focus, transaction, or container keys.
- `@FocusedValue` plus `focusedSceneValue` for active-window commands and menu validation.
- `WindowGroup`, auxiliary `Window`, and `Settings` for native macOS scene composition.
- `fileImporter`, `fileExporter`, `Transferable`, `draggable`, and `dropDestination` for sandboxed file and transfer workflows.
- `Table` for dense columnar macOS data.
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

The only application target requires macOS 26. Use current APIs directly and do not add `if #available`, legacy branches, or compatibility wrappers. Revisit availability only when `Package.swift` gains a real second platform or a lower deployment target.
