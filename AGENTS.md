# Agent instructions

## Mission

Maintain this repository as a small, modern, cross-Apple SwiftUI starter. Prefer clear platform APIs and explicit boundaries over abstractions that exist only to anticipate future scale.

## Before changing code

1. Read `README.md` and the relevant file under `docs/`.
2. Inspect `project.yml`, `Package.swift`, and neighboring source files.
3. For a feature or behavior change, record concise answers to the refinement questions in `docs/REFINEMENT.md` or a feature-specific design note.
4. Use the matching skill in `.pi/skills/` for SwiftUI work, design review, or release work.

## Architecture rules

- Put value types and pure transformations in `Domain`.
- Define narrow dependency protocols in `Infrastructure`; inject implementations at the app boundary.
- Keep shared observable state `@MainActor` and owned with `@State`.
- Keep views declarative. Move business logic and dependency calls out of `body`.
- Organise by feature as the app grows; one meaningful type per Swift file.
- Do not add a third-party dependency without explaining why an Apple API or a small local implementation is insufficient.
- Do not add UIKit/AppKit wrappers unless SwiftUI lacks the required capability; isolate wrappers behind a platform seam.
- Preserve Swift 6 strict-concurrency correctness. Never silence it with broad `@unchecked Sendable` annotations.

## Design rules

- Start with Apple system containers, controls, fonts, colors, symbols, menus, and presentation APIs.
- Provide loading, empty, filtered-empty, failure, retry, and populated states.
- Support Dynamic Type, VoiceOver, Voice Control, keyboard/focus, Reduce Motion, increased contrast, and Differentiate Without Color.
- Keep touch targets at least 44 by 44 points.
- Use platform-appropriate navigation rather than forcing identical layouts everywhere.
- Avoid fixed screen dimensions, color-only meaning, hidden labels, fake macOS chrome, and decorative animation.

## Style

- Follow the Swift API Design Guidelines and the local formatter/linter configurations.
- Aim for 100-character lines; 120 is the formatter limit and 140 is a hard lint error.
- Prefer inferred types where obvious, explicit names over abbreviations, and `ID`/`URL` acronym casing.
- Prefer `async`/`await`, actors, format styles, Swift-native string APIs, and modern SwiftUI modifiers.
- No force unwraps, force tries, direct `print`, swallowed user-action errors, or secrets in source.

## Generated files

`Starter.xcodeproj` is generated and ignored. Change `project.yml`, then run `make generate`. Do not commit local Xcode user data, build products, signing material, or notarisation credentials.

## Required validation

Run the strongest available subset and state exactly what was not run:

```sh
make validate
make lint
make test
make build-ios
make build-macos
make build-tvos
make build-visionos
make build-watchos
```

On non-macOS hosts, only `make validate` is expected to work. Never report native compilation as successful without Xcode output.

## Completion checklist

- Behavior has deterministic tests.
- User-visible failures are presented and recoverable where possible.
- Accessibility and each target platform have been reviewed.
- Documentation and `project.yml` match implementation.
- No generated project, secrets, build output, or signing files are committed.
- `NOTICE.md` is updated if new source or substantial guidance is incorporated.
