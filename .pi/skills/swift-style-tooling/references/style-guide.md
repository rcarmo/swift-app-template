# Local Swift style guide

## Formatting

- Two-space indentation.
- Aim for 100-character lines; formatter limit 120, lint hard limit 140.
- Trim trailing whitespace and end every file with a newline.
- Group/sort imports with `@testable` imports last.
- Use trailing commas in multi-line collections/arguments where formatter policy applies.
- Let SwiftFormat handle syntactic layout; do not hand-fight it.

## Naming

- UpperCamelCase for types/protocols; lowerCamelCase otherwise.
- Boolean names read as predicates: `is`, `has`, `can`, `should`.
- Acronyms are `URL`, `ID`, `HTTP` except at the start of a lower-camel identifier (`url`, `userID`).
- Event handlers describe what occurred (`didSelectItem`) rather than generic `handle` names.
- Avoid Objective-C prefixes and unexplained abbreviations.

## Types and expressions

- Infer obvious types from the right-hand value; write an explicit type when it clarifies abstraction or resolves ambiguity.
- Prefer static member lookup and synthesized conformances/initializers where clear.
- Use shorthand optional binding and switch/if expressions.
- Prefer loops to `forEach` when control flow, throwing, async work, or optional chains make intent clearer.
- Prefer `some Protocol` for opaque returns/parameters where identity matters; use `any Protocol` for existential storage.
- Mark classes `final` unless subclassing is designed and tested.

## File organization

One meaningful type per Swift file. Place extensions next to the type when private/local, or in a named file when they represent a substantial protocol/domain concern. Use `MARK` sections only when a type is large enough to benefit; extracting the type may be better.

## Logging and errors

Use `Logger` categories and privacy annotations. Never use logs as the only response to a failed user action. Error text should be actionable and separate technical diagnostics from user-facing wording.

## Tests

Test names are lower camel case and describe behavior. Avoid private test methods/types unless access control conveys a real constraint. Do not use force unwraps/tries to shorten fixture code.
