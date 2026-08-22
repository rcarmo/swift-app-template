---
name: apple-privacy-security
description: Design or audit macOS permissions, privacy metadata, entitlements, sandbox access, Keychain use, sensitive logging, network/file boundaries, and secure defaults.
license: MIT
metadata:
  version: "2.0"
  provenance: Independently adapted from tqbf/swiftui-app capability notes, twostraws hygiene guidance, and this template's sandbox policy; see NOTICE.md.
---

# macOS privacy and security

Read `references/privacy-and-permissions.md` when adding a capability, entitlement, permission prompt, credential, network client, file access, analytics, diagnostics, clipboard, camera, location, contacts, or release privacy declaration.

The starter enables the application sandbox and no additional entitlement. Add capabilities only for product behaviour that exists.

## Workflow

1. Minimise data collection and capability scope before implementation.
2. Record the data, purpose, retention, sharing, deletion, and user control.
3. Add only the required plist usage descriptions, sandbox entitlements, privacy-manifest reasons, and distribution declarations.
4. Request permission in context and design denial, restriction, later grant/revocation, and Settings-change behaviour.
5. Store credentials through an injected Keychain service; keep secrets out of source, preferences, logs, and crash metadata.
6. Keep ATS and platform trust validation enabled; document any narrower trust requirement and its rotation/failure plan.
7. Test first request, denial, revocation, offline operation, migration, and data deletion/export as applicable.
8. Inspect the entitlements and plist in the assembled, signed `.app` before release.

## Guardrails

- No secrets in `@AppStorage`, plist, source, scripts, fixtures, screenshots, or workflow logs.
- No broad sandbox entitlement for hypothetical features.
- Do not force-open Settings as the only denied path; explain what remains usable.
- Redact sensitive values in `Logger`; do not use `print` for application diagnostics.
- Do not disable ATS or certificate validation without a narrow reviewed requirement.
- Do not add analytics or telemetry until consent, policy, retention, and deletion requirements are defined.

## Output

Provide the data/capability inventory, plist and entitlement changes, denial/revocation behaviour, storage/retention, tests, and release declarations. Flag legal or policy questions rather than guessing.
