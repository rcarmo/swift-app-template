#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
app_name="$(sed -n 's/^APP_NAME ?= //p' "$root/Makefile" | head -n 1)"
[[ -n "$app_name" ]] || { echo "error: could not resolve APP_NAME from Makefile" >&2; exit 1; }
tmp="$(mktemp -d "${TMPDIR:-/tmp}/swift-template-make.XXXXXX")"
log="$tmp/calls.log"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin"

cat > "$tmp/bin/uname" <<'SCRIPT'
#!/bin/sh
echo Darwin
SCRIPT
cat > "$tmp/bin/xcode-select" <<'SCRIPT'
#!/bin/sh
if [ "${1:-}" = "-p" ]; then
  echo /Applications/Xcode.app/Contents/Developer
fi
exit 0
SCRIPT
cat > "$tmp/bin/xcodebuild" <<'SCRIPT'
#!/bin/sh
printf 'xcodebuild %s\n' "$*" >> "$MOCK_LOG"
if [ "${1:-}" = "-version" ]; then
  printf 'Xcode 16.4\nBuild version 16F6\n'
elif [ "${1:-}" = "-showsdks" ]; then
  cat <<'SDKS'
iOS Simulator -sdk iphonesimulator18.5
macOS -sdk macosx15.5
tvOS Simulator -sdk appletvsimulator18.5
watchOS Simulator -sdk watchsimulator11.5
visionOS Simulator -sdk xrsimulator2.5
SDKS
fi
if [ "${1:-}" = "build" ] && [ "${MOCK_FAIL_BUILD:-0}" = "1" ]; then
  exit 17
fi
exit 0
SCRIPT
cat > "$tmp/bin/xcrun" <<'SCRIPT'
#!/bin/sh
printf 'xcrun %s\n' "$*" >> "$MOCK_LOG"
if [ "${1:-}" = "--find" ]; then echo /mock/usr/bin/swift; fi
SCRIPT

for command in brew xcodegen swift swiftformat swiftlint; do
  cat > "$tmp/bin/$command" <<SCRIPT
#!/bin/sh
printf '$command %s\\n' "\$*" >> "\$MOCK_LOG"
exit 0
SCRIPT
done
chmod +x "$tmp/bin"/*

run_make() {
  PATH="$tmp/bin:$PATH" MOCK_LOG="$log" make --no-print-directory -C "$root" "$@"
}

require_call() {
  pattern="$1"
  grep -q -- "$pattern" "$log" || {
    echo "error: mocked workflow did not call: $pattern" >&2
    exit 1
  }
}

: > "$log"
run_make bootstrap >/dev/null
require_call '^brew bundle --file=Brewfile$'
require_call '^swiftformat --lint '
require_call '^swiftlint lint --strict '
require_call '^swift test$'
require_call '^xcodegen generate$'
require_call "^xcodebuild -resolvePackageDependencies .*$app_name-macOS"
require_call "^xcodebuild build .*$app_name-macOS .*destination platform=macOS"
[[ "$(grep -c '^xcodegen generate$' "$log")" -eq 1 ]] || {
  echo "error: default bootstrap should generate the Xcode project exactly once" >&2
  exit 1
}

: > "$log"
run_make bootstrap-all >/dev/null
require_call "xcodebuild build .*$app_name-iOS .*generic/platform=iOS Simulator"
require_call "xcodebuild build .*$app_name-iOS .*variant=Mac Catalyst"
require_call "xcodebuild build .*$app_name-macOS .*platform=macOS"
require_call "xcodebuild build .*$app_name-tvOS .*generic/platform=tvOS Simulator"
require_call "xcodebuild build .*$app_name-visionOS .*generic/platform=visionOS Simulator"
require_call "xcodebuild build .*$app_name-watchOS .*generic/platform=watchOS Simulator"

: > "$log"
if PATH="$tmp/bin:$PATH" MOCK_LOG="$log" MOCK_FAIL_BUILD=1 \
  make --no-print-directory -C "$root" bootstrap >/dev/null 2>&1; then
  echo "error: bootstrap ignored a failing native build" >&2
  exit 1
fi
require_call "xcodebuild build .*$app_name-macOS"

echo "Make workflow checks passed (mocked orchestration; no native compilation)."
