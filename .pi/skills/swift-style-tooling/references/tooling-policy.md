# Formatter and linter policy

## Division of responsibility

SwiftFormat owns deterministic syntax/layout and safe simplifications. SwiftLint owns correctness-oriented/static-analysis rules and project-specific prohibited patterns. Avoid configuring both to fight over the same formatting choice.

## Commands

```sh
make format   # mutate source with SwiftFormat, then safe SwiftLint fixes
make lint     # read-only SwiftFormat lint and strict SwiftLint
```

Review auto-fixes before commit. CI runs lint from a clean checkout.

## Adding a rule

1. Show a real defect or recurring review cost.
2. Decide whether correction is mechanically behavior-preserving.
3. Enable in the appropriate tool.
4. Run against the whole repository.
5. Fix violations without blanket exclusions.
6. Document exceptions and version requirements.

## Suppression

Use the narrowest disable with a comment proving why the pattern is safe and why a better alternative is unavailable. A file-wide disable requires architectural justification. Remove stale disables when code changes.

## Version changes

Tool updates can add or rename rules. Update `Brewfile` assumptions, configs, CI, and formatted source together. On CI runner changes, confirm SwiftFormat/SwiftLint support the installed Swift syntax.
