# Local Apple-development skills

These skills are self-contained, project-local adaptations arranged by functional domain. Agents should load the narrowest applicable skills; `swiftui-implementation` is the general orchestrator.

## Routing table

| Task | Skill |
|---|---|
| implement/review SwiftUI views and modern APIs | `swiftui-implementation` |
| state ownership, dependencies, persistence, caches | `swift-architecture` |
| actors, tasks, cancellation, Sendable, races | `swift-concurrency` |
| stacks, split views, tabs, sheets, dialogs, deep links | `swiftui-navigation` |
| VoiceOver, Dynamic Type, motion, contrast, focus | `apple-accessibility` |
| native layout, visual hierarchy, interaction, platform adaptation | `apple-design-review` |
| rendering, scrolling, startup, memory, energy profiling | `swiftui-performance` |
| runtime/layout/hosting/restoration hardening | `swiftui-hardening` |
| type scale, readable measure, custom fonts | `apple-typography` |
| unit/model/integration/UI testing | `swift-testing` |
| naming, readability, SwiftFormat, SwiftLint, logging | `swift-style-tooling` |
| Package.swift, Make, app bundling, CI, rename/icons | `apple-project-workflows` |
| String Catalogs, formatting, plurals, RTL | `apple-localization` |
| permissions, entitlements, privacy, keychain, sandbox | `apple-privacy-security` |
| signing, notarisation, packaging, store/direct release | `apple-release` |

## Upstream-to-local mapping

### twostraws/swiftui-agent-skill (`swiftui-pro`)

Its audited domains are covered locally as follows:

| Upstream reference | Local domain |
|---|---|
| API and views | `swiftui-implementation/references/` |
| performance | `swiftui-performance` |
| data | `swift-architecture` |
| Swift concurrency | `swift-concurrency` |
| navigation | `swiftui-navigation` |
| accessibility | `apple-accessibility` |
| design | `apple-design-review` and `apple-typography` |
| hygiene/testing | `swift-testing`, `swift-style-tooling`, `apple-localization`, `apple-privacy-security` |

### airbnb/swift

The readability, naming, testing, formatter/linter, logging, sendability, and file-literal guidance is adapted into `swift-style-tooling` and `swift-testing`. The repository uses smaller local `.swiftformat` and `.swiftlint.yml` configurations rather than vendoring Airbnb's command plugin.

### rcarmo/EditorBridge

The first-party MIT-licensed repository provides the implementation precedent for SwiftPM library/executable products, manual macOS `.app` assembly, and bundle-level signing. The local project/release skills adapt that topology to this template's architecture and policies; exact provenance is in `NOTICE.md`.

### tqbf/swiftui-app

Because the audited repository had no explicit licence, only high-level concepts were independently reimplemented. SwiftPM build/release/rename/icon ideas are independently expressed in `apple-project-workflows` and `apple-release`; no unlicensed source skill text or code is copied.

### ceorkm/macos-design-skill

Its layout, interaction, visual hierarchy, keyboard, search, drag/drop, appearance, and progressive-disclosure concerns are adapted into `apple-design-review`. Web/Electron CSS and fake macOS chrome prescriptions were deliberately excluded in favor of native SwiftUI/system behavior.

## Loading order for a feature

1. `swiftui-implementation`
2. architecture/concurrency/navigation skills that match behavior
3. accessibility + design + typography for UI
4. performance for measured responsiveness work; hardening for live runtime/layout defects
5. testing + style/tooling
6. localization/privacy if user text or capabilities change
7. project/release skills only when configuration or distribution changes

All source provenance and licence boundaries are in the repository root `NOTICE.md`.
