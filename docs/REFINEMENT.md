# Template refinement notes

1. **Problem:** repeated macOS app setup tends to mix UI, dependencies, packaging, and release work; the template provides a tested SwiftPM boundary.
2. **Primary user:** a Swift developer or coding agent beginning a native macOS SwiftUI product.
3. **Success:** rename once, build and test with SwiftPM, launch a signed `.app`, and understand release choices without an Xcode project.
4. **MVP:** a searchable master/detail sample backed by an injected service, with loading/error/empty states.
5. **Out of scope:** production backend, account system, analytics, opinionated persistence, paid dependencies, App Store submission automation, and speculative iPadOS/iOS bundles.
6. **Surfaces:** SwiftPM library and executable, tests, packaging scripts, docs, workflows, and agent skills.
7. **Constraints:** Swift 6 strict concurrency; macOS 14 minimum; native app assembly requires macOS command-line tools.
8. **Failures:** dependencies expose visible retry state; scripts fail early with actionable prerequisites.
9. **Persistence:** omitted until product semantics are known; use a service adapter.
10. **Alignment:** native macOS conventions, modern SwiftUI, readable style, SwiftPM as the build source of truth.
11. **First slice:** domain and injected application model, then native shared UI.
12. **Avoid in v1:** coordinators, service locators, architecture frameworks, copied upstream implementation, and premature platform wrappers.
13. **Naming:** `Starter` is a valid package product and placeholder app name; rename validates replacements.
14. **Inputs/outputs:** item service input; rendered macOS UI and packaged macOS artifact output.
15. **Existing behavior:** generated build products remain disposable.
16. **Performance:** no work-heavy view bodies; asynchronous loading is cancellable through SwiftUI tasks.
17. **Security:** sandbox enabled; no committed credentials; minimal entitlements by default.
18. **Export:** notarised macOS zip plus checksum; data export is product-specific.
19. **Proof:** static checks, formatter/linter, SwiftPM model/domain tests, executable compilation, real `.app` launch, and accessibility review.
20. **Done:** scaffold, docs, provenance, and automation exist; unavailable macOS-native validation is reported honestly.
