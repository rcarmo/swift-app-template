#!/usr/bin/env bash
set -euo pipefail

new_name="${1:-}"
new_bundle_id="${2:-}"
[[ "$new_name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || {
  echo "usage: $0 NewAppName [reverse.dns.bundle-id]" >&2
  echo "App name must also be a valid Swift identifier." >&2
  exit 64
}
[[ "$new_name" != "Starter" ]] || { echo "Nothing to rename."; exit 0; }

lower_name="$(printf '%s' "$new_name" | tr '[:upper:]_' '[:lower:]-')"
new_bundle_id="${new_bundle_id:-com.example.$lower_name}"
[[ "$new_bundle_id" =~ ^[A-Za-z0-9.-]+$ && "$new_bundle_id" == *.* ]] || {
  echo "error: bundle identifier must contain dot-separated alphanumeric components" >&2
  exit 64
}

export NEW_NAME="$new_name" NEW_BUNDLE_ID="$new_bundle_id"
while IFS= read -r -d '' file; do
  perl -0pi -e 's/com\.example\.starter/$ENV{NEW_BUNDLE_ID}/g; s/Starter/$ENV{NEW_NAME}/g' "$file"
done < <(find . -type f \
  -not -path './.git/*' -not -path './.build/*' -not -path './build/*' \
  -not -path './dist/*' -not -path './scripts/rename.sh' \
  \( -name '*.swift' -o -name '*.sh' -o -name '*.md' -o -name '*.yml' \
     -o -name '*.yaml' -o -name '*.plist' -o -name '*.json' -o -name '*.entitlements' \
     -o -name 'Makefile' -o -name 'VERSION' -o -name '.gitignore' \
     -o -name '.swiftformat' -o -name '.swiftlint.yml' \) -print0)

mv Sources/Application/StarterApp.swift "Sources/Application/${new_name}App.swift"
mv Config/Starter.entitlements "Config/${new_name}.entitlements"
echo "Renamed Starter to $new_name ($new_bundle_id). Run make validate, make test, and make build."
