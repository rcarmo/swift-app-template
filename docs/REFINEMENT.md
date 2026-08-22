# Template refinement notes

1. **Problem:** repeated Apple app setup tends to mix UI, dependencies, tooling, and release work; the template provides a tested starting boundary.
2. **Primary user:** a Swift developer or coding agent beginning a native SwiftUI product.
3. **Success:** rename once, generate a project, run tests, build each platform, and understand the remaining release choices.
4. **MVP:** a searchable master/detail sample backed by an injected service, with loading/error/empty states.
5. **Out of scope:** production backend, account system, analytics, opinionated persistence, paid dependencies, store submission automation.
6. **Surfaces:** shared Swift package, app entry point, XcodeGen targets, tests, CI, scripts, docs, agent skills.
7. **Constraints:** Swift 6 strict concurrency; iOS 17/macOS 14 peer-era platforms; native build requires macOS/Xcode.
8. **Failures:** dependencies expose a visible retry state; scripts fail early with actionable prerequisites.
9. **Persistence:** intentionally omitted until product semantics are known; use a service adapter.
10. **Alignment:** Apple platform conventions, modern SwiftUI guidance, readable/autocorrectable style, generated projects.
11. **First slice:** pure domain and injected application model, then shared UI.
12. **Avoid in v1:** coordinators, service locators, third-party architecture frameworks, copied upstream implementation.
13. **Naming:** `Starter` is a valid Swift target and placeholder app name; rename helper validates replacements.
14. **Inputs/outputs:** item service input; rendered platform UI and packaged macOS artifact output.
15. **Existing behavior:** not applicable to a new template; generated files remain disposable.
16. **Performance:** no work-heavy view bodies; asynchronous loading is cancellable through SwiftUI tasks.
17. **Security:** sandbox enabled for macOS; no committed credentials; minimal entitlements by default.
18. **Export:** macOS release zip plus checksum; data export is product-specific.
19. **Proof:** static checks, formatter/linter, model/domain tests, per-platform compilation, manual accessibility matrix.
20. **Done:** scaffold, docs, provenance, and automation exist; Linux-safe checks pass; macOS-native validation is clearly outstanding until run.
