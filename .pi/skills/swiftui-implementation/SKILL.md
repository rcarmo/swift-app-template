---
name: swiftui-implementation
description: Implement, refactor, or review macOS-first SwiftUI features using modern APIs, maintainable view composition, correct data flow, performance checks, and project validation.
license: MIT
metadata:
  version: "2.0"
  provenance: Adapted from twostraws/swiftui-agent-skill and local template conventions; see NOTICE.md.
---

# SwiftUI implementation

Use this as the main entry point for any SwiftUI code change. It orchestrates the focused local skills; load only the domains relevant to the task.

## Read first

1. `AGENTS.md` and the relevant document under `docs/`.
2. Neighboring files in the feature.
3. `references/modern-api.md` and `references/view-composition.md`.
4. Other skills as needed:
   - state/dependencies: `../swift-architecture/SKILL.md`
   - asynchronous work: `../swift-concurrency/SKILL.md`
   - navigation, sheets, alerts: `../swiftui-navigation/SKILL.md`
   - accessibility: `../apple-accessibility/SKILL.md`
   - visual/platform behavior: `../apple-design-review/SKILL.md`
   - typography: `../apple-typography/SKILL.md`
   - profiling/performance: `../swiftui-performance/SKILL.md`
   - runtime/layout hardening: `../swiftui-hardening/SKILL.md`
   - tests: `../swift-testing/SKILL.md`
   - style/tooling: `../swift-style-tooling/SKILL.md`
   - project targets/builds: `../apple-project-workflows/SKILL.md`
   - user-facing text: `../apple-localization/SKILL.md`
   - permissions, data, files, network, secrets: `../apple-privacy-security/SKILL.md`
   - distribution implications: `../apple-release/SKILL.md`

## Implementation workflow

1. Define the user outcome and affected platforms.
2. Enumerate loading, populated, empty, search-empty, failure, permission, offline, and cancellation states that apply.
3. Identify the state owner, dependency boundary, navigation value, and test seam before writing views.
4. Implement the narrowest vertical slice with system components.
5. Extract meaningful subviews into feature-owned files; do not create abstractions with only one speculative use.
6. Add deterministic tests for pure behavior and state transitions.
7. Review modern API, view identity, accessibility, platform adaptation, and performance.
8. Run the strongest available gates and report anything not run.

## Baseline policy

- Use Swift 6 strict concurrency and current APIs available at the deployment target in `Package.swift`.
- Prefer pure SwiftUI. Add UIKit/AppKit bridges only when the required capability is unavailable, and isolate the bridge.
- Do not add third-party packages without explicit justification and approval.
- Keep one meaningful type per file and organise by feature.
- Report genuine correctness, accessibility, performance, or maintenance issues; do not invent findings to fill a review.

## Review output

Group findings by file. For each issue, give the line or symbol, consequence, applicable rule, and smallest correction. End with a prioritized summary and validation status. Skip files without findings.
