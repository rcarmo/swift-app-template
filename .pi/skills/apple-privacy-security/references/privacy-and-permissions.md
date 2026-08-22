# Privacy, permissions, and security

## Capability inventory

For each capability record:

- API/data accessed;
- user-visible purpose;
- platforms;
- usage-description key;
- entitlement/sandbox capability;
- privacy manifest/App Store declaration;
- retention/sharing/deletion;
- denied/restricted fallback;
- test procedure.

Usage text must be specific and user-facing. Entitlements and usage descriptions solve different layers: the sandbox grants capability; the usage description explains a protected-data prompt. Some APIs require privacy-manifest reasons as well.

## Permission UX

Ask only at the moment the feature needs access. Avoid launch-time prompt cascades. The pre-prompt must not manipulate or imitate the system alert. After denial, keep unrelated functionality usable and offer a clear route to retry or Settings only when useful.

## Secrets and credentials

Use Keychain for tokens/passwords and keep access groups minimal. Inject a credential service so tests use a fake. Never embed service secrets in a client app; use user credentials or a backend-issued scoped token. Redact logs and error payloads.

## Files and sandbox

Use user-selected open/save panels and security-scoped bookmarks for durable access where required. Release scope promptly. Validate moved/deleted bookmarks and provide recovery. Do not assume arbitrary filesystem access on sandboxed macOS/Catalyst.

## Network

Prefer URLSession and ATS defaults. Set timeouts, cancellation, status validation, bounded response handling, and privacy-aware logging. Certificate pinning creates operational risk and needs a rotation/failure plan. Never accept all certificates.

## Data lifecycle

Define encryption-at-rest needs, migration, backup/sync inclusion, export, account deletion, local wipe, cache expiry, and crash/analytics collection. Sensitive data should not leak into widget snapshots, notifications, clipboard, Spotlight, screenshots, or state restoration.

## Verification

Inspect the built product's entitlements and Info.plist, reset simulator/device permissions, test deny/revoke/reinstall/restore, inspect logs and network traffic, and confirm release privacy answers match code and dependencies.
