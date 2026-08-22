---
name: apple-privacy-security
description: Design or audit permissions, privacy declarations, entitlements, sandbox access, keychain use, sensitive logging, network/file boundaries, and secure defaults for Apple apps.
license: MIT
metadata:
  version: "1.0"
  provenance: Independently adapted from tqbf/swiftui-app capability notes, twostraws hygiene guidance, and this template's sandbox policy; see NOTICE.md.
---

# Apple privacy and security

Read `references/privacy-and-permissions.md`. Use whenever adding a capability, entitlement, permission prompt, credential, network client, file access, analytics, diagnostics, clipboard/camera/location/contact access, or release privacy declaration.

## Workflow

1. Minimize data collection and capability scope before implementation.
2. Identify data, purpose, retention, sharing, deletion, and user control.
3. Add only the required usage descriptions, entitlements, sandbox access, privacy manifest/API reasons, and App Store declarations.
4. Request permission in context, after explaining value; design denied, restricted, unavailable, and settings-change paths.
5. Store credentials in Keychain through an injected service; keep secrets out of source, preferences, logs, and crash metadata.
6. Use secure transport and validate server trust requirements without disabling platform protections.
7. Test first request, denial, later grant/revocation, offline behavior, migration, and data deletion/export.
8. Re-audit signed entitlements and privacy metadata before release.

## Guardrails

- No secrets in `@AppStorage`, plist, source, scripts, fixtures, screenshots, or CI logs.
- No broad sandbox entitlement “just in case.”
- No force-open of Settings as the only denied path; explain what remains usable.
- No sensitive values in `print`/Logger without privacy redaction.
- No disabling ATS/certificate validation without a narrow documented requirement and security review.
- No analytics/telemetry before consent and policy requirements are understood.

## Output

Provide a data/capability inventory, required metadata/entitlements, denied/revoked behavior, storage/retention, tests, and release declarations. Flag legal/policy questions rather than guessing.
