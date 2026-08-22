#!/usr/bin/env bash
set -euo pipefail

[[ "$(uname -s)" == "Darwin" ]] || { echo "error: notary setup requires macOS" >&2; exit 1; }
: "${APPLE_ID:?Set APPLE_ID to your Apple ID email address}"
: "${TEAM_ID:?Set TEAM_ID to your Apple Developer team ID}"
profile="${NOTARY_PROFILE:-starter-notary}"

xcrun notarytool store-credentials "$profile" --apple-id "$APPLE_ID" --team-id "$TEAM_ID"
echo "Stored notarization credentials in keychain profile '$profile'."
