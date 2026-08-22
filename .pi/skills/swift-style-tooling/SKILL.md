---
name: swift-style-tooling
description: Apply or review Swift naming, readability, file organisation, formatter/linter policy, logging hygiene, and automated quality gates for this template.
license: MIT
metadata:
  version: "1.0"
  provenance: Adapted from airbnb/swift and local tooling policy; see NOTICE.md.
---

# Swift style and tooling

Read `.swiftformat`, `.swiftlint.yml`, and `references/style-guide.md`. Use when writing Swift, changing formatter/linter configuration, resolving style CI, or reviewing readability.

## Principles

- Readability, simplicity, and correctness outrank brevity.
- Formatting rules should be autocorrectable and behaviour-preserving.
- Lint rules should target correctness, unsafe patterns, or conventions without safe automatic replacement.
- Follow the Swift API Design Guidelines; local rules supplement rather than contradict them.
- Do not create noisy rules that train developers to ignore warnings.

## Workflow

1. Write clear code before optimizing line count.
2. Run `make format` after Swift edits when SwiftFormat and SwiftLint are installed.
3. Review formatter changes; autocorrection is not a substitute for understanding.
4. Run `make lint`; commit with zero warnings or errors.
5. If suppressing a rule, narrow it to one line/scope and explain why the code is safe.
6. Change config and representative code/tests in the same commit.

## Guardrails

- No direct `print`, `debugPrint`, `dump`, or `_printChanges` in committed application code; use `os.Logger` with privacy annotations.
- No `@unchecked Sendable` without a narrow suppression and safety proof.
- Use `#fileID` by default, `#filePath` only when the full path matters.
- No force unwrap/try, implicitly unwrapped optionals, stale disables, or committed secrets.
- Keep generated/build/vendor directories excluded.

## Output

Distinguish formatter output, lint violations, and human-review guidance. Record tool versions when relevant. Do not call a personal preference a project rule unless it appears in configuration or this skill.
