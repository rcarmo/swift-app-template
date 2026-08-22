# Template refinement notes

1. **Problem:** repeated macOS app setup tends to mix UI, dependencies, packaging, and release work; the template provides a verifiable SwiftPM boundary.
2. **Primary user:** a Swift developer or coding agent beginning a native macOS SwiftUI product.
3. **Success:** rename once, build and test with SwiftPM 6.2, launch a signed `.app`, and understand release choices without an Xcode project.
4. **MVP:** a searchable collection/detail sample backed by an injected service, with loading/error/empty states and representative desktop interactions.
5. **Out of scope:** production backend, account system, analytics, opinionated persistence, paid dependencies, App Store submission automation, and a speculative iPadOS application.
6. **Surfaces:** SwiftPM library and executable, tests, packaging scripts, docs, workflows, and agent skills.
7. **Constraints:** macOS 26 minimum; Swift 6.2 language mode and strict concurrency; native app assembly requires macOS command-line tools.
8. **Failures:** dependencies expose visible retry state; scripts fail early with actionable prerequisites.
9. **Persistence:** omitted until product semantics are known; use a service adapter.
10. **Alignment:** native macOS conventions, Observation, actor-backed services, focused scene actions, Swift Testing, and SwiftPM as the build source of truth.
11. **First slice:** domain and injected application model, then native shared UI and scene composition.
12. **Avoid in v1:** coordinators, service locators, architecture frameworks, copied upstream implementation, global notification command buses, and premature platform wrappers.
13. **Naming:** `Starter` is a valid package product and placeholder app name; rename validates replacements.
14. **Inputs/outputs:** item service and user-selected files as inputs; rendered macOS UI and packaged macOS artefact as outputs.
15. **Existing behaviour:** generated build products remain disposable.
16. **Performance:** no work-heavy view bodies; asynchronous loading is owned by SwiftUI tasks; explicit concurrent work has narrow boundaries.
17. **Security:** sandbox and user-selected file access are enabled; no committed credentials; remove unused entitlements in derived products.
18. **Export:** direct releases produce a notarised macOS zip plus checksum; the sample also demonstrates one-item document export.
19. **Automated proof:** static checks, optional formatter/linter, SwiftPM model/domain tests, executable compilation, app assembly, plist substitution, and signing verification where the relevant tools are run.
20. **Manual proof:** real app launch, windows, menus, shortcuts, focus, import/export, drag/drop, appearance, accessibility, Gatekeeper, and notarisation acceptance must be recorded on macOS; they are not implied by automated checks.
