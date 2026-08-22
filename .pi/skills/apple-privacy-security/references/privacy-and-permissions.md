# Privacy, permissions, and security

## Capability inventory

For each capability record:

- API and data accessed;
- user-visible purpose;
- plist usage-description key, if required;
- entitlement or sandbox capability;
- privacy-manifest reason and distribution declaration, if required;
- retention, sharing, and deletion;
- denied or revoked fallback;
- verification procedure.

Usage text must describe the concrete user benefit. Entitlements and usage descriptions cover different layers: an entitlement grants capability; a usage description explains a protected-data prompt. Required-reason APIs may also need a privacy manifest.

## Permission experience

Ask when the feature needs access, not in a launch-time prompt cascade. A pre-prompt must not imitate or manipulate the system alert. After denial, leave unrelated functions usable and offer retry or a route to System Settings only when useful.

## Secrets and credentials

Store tokens and passwords in Keychain with minimal access groups. Inject a credential service so tests can use a fake. Never embed a service secret in a client application; use user credentials or a scoped backend-issued token. Redact logs and error payloads.

## Files and sandbox

Use `NSOpenPanel`/`NSSavePanel` directly or SwiftUI import/export APIs for user-selected files. Persist security-scoped bookmarks only when durable access is needed, balance access calls, and recover from stale or moved bookmarks. Do not assume arbitrary filesystem access in the sandbox.

## Network

Prefer `URLSession` and ATS defaults. Set timeouts, support cancellation, validate status and content size, and keep logs privacy-aware. Certificate pinning creates operational risk and needs a rotation and failure plan. Never accept all certificates.

## Data lifecycle

Define encryption-at-rest needs, migration, backup or sync inclusion, export, account deletion, local wipe, cache expiry, and crash/analytics collection. Prevent sensitive data from leaking into notifications, clipboard, Spotlight, screenshots, state restoration, or diagnostic attachments.

## Verification

Inspect the assembled product rather than only source templates:

```sh
codesign -d --entitlements :- build/Starter.app
plutil -p build/Starter.app/Contents/Info.plist
```

Reset the relevant macOS privacy permission with `tccutil` or System Settings when safe, then test first use, denial, later grant/revocation, relaunch, and reinstall behaviour. Inspect logs and network traffic. Confirm direct-release privacy claims match the application and its dependencies; if a separate store path is introduced, audit its declarations independently.
