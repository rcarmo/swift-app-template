#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
tmp="$(mktemp -d "${TMPDIR:-/tmp}/swift-template-make.XXXXXX")"
log="$tmp/calls.log"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin"

cat > "$tmp/bin/uname" <<'SCRIPT'
#!/bin/sh
echo Darwin
SCRIPT
cat > "$tmp/bin/swift" <<'SCRIPT'
#!/bin/sh
printf 'swift %s\n' "$*" >> "$MOCK_LOG"
if [ "${1:-}" = "--version" ]; then echo 'Swift version 6.2'; fi
exit "${MOCK_SWIFT_EXIT:-0}"
SCRIPT
for command in codesign xcrun swiftformat swiftlint; do
  cat > "$tmp/bin/$command" <<SCRIPT
#!/bin/sh
printf '$command %s\n' "\$*" >> "\$MOCK_LOG"
exit 0
SCRIPT
done
chmod +x "$tmp/bin"/*

run_make() {
  PATH="$tmp/bin:$PATH" MOCK_LOG="$log" make --no-print-directory -C "$root" "$@"
}
require_call() {
  grep -q -- "$1" "$log" || { echo "error: mocked workflow did not call: $1" >&2; exit 1; }
}
reject_call() {
  ! grep -q -- "$1" "$log" || { echo "error: forbidden workflow call: $1" >&2; exit 1; }
}

: > "$log"
run_make package-build >/dev/null
require_call '^swift build --product Starter --configuration debug$'
reject_call 'xcodebuild\|xcodegen\|brew'

: > "$log"
run_make test >/dev/null
require_call '^swift test$'
reject_call 'xcodebuild\|xcodegen\|brew'

: > "$log"
run_make lint >/dev/null
require_call '^swiftformat --lint '
require_call '^swiftlint lint --strict '
reject_call 'xcodebuild\|xcodegen\|brew'

: > "$log"
if PATH="$tmp/bin:$PATH" MOCK_LOG="$log" MOCK_SWIFT_EXIT=17 \
  make --no-print-directory -C "$root" package-build >/dev/null 2>&1; then
  echo "error: package-build ignored a failing SwiftPM build" >&2
  exit 1
fi

printf 'Make workflow checks passed (mocked SwiftPM orchestration; no native compilation).\n'
