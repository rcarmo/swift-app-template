# Formatter and linter policy

## Division of responsibility

SwiftFormat owns deterministic syntax/layout and safe simplifications. SwiftLint owns correctness-oriented/static-analysis rules and project-specific prohibited patterns. Avoid configuring both to fight over the same formatting choice.

## Commands

```sh
make format   # mutate source with SwiftFormat, then safe SwiftLint fixes
make lint     # read-only SwiftFormat lint and strict SwiftLint
```

Review auto-fixes before commit. The opt-in CI template does not currently install or run SwiftFormat/SwiftLint; `make lint` remains a local/explicit gate until the derived repository adds a pinned CI installation step.

## Adding a rule

1. Show a real defect or recurring review cost.
2. Decide whether correction is mechanically behaviour-preserving.
3. Enable in the appropriate tool.
4. Run against the whole repository.
5. Fix violations without blanket exclusions.
6. Document exceptions and version requirements.

## Suppression

Use the narrowest disable with a comment proving why the pattern is safe and why a better alternative is unavailable. A file-wide disable requires architectural justification. Remove stale disables when code changes.

## Version changes

Tool updates can add or rename rules. Record the tested versions, update optional installation guidance and configurations, and reformat representative source together. If lint is added to CI, pin or otherwise control tool installation and confirm support for the runner's Swift syntax.
