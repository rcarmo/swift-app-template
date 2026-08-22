#!/usr/bin/env bash
set -euo pipefail

required=(Package.swift Makefile README.md NOTICE.md AGENTS.md VERSION Resources/Info.plist \
  Config/Starter.entitlements Sources/Application/StarterApp.swift \
  Sources/AppCore/Application/AppModel.swift scripts/build-macos-app.sh \
  .github/workflows/ci.yml.disabled .github/workflows/release.yml.disabled \
  .github/workflows/prune-actions-artifacts.yml.disabled)
for file in "${required[@]}"; do
  [[ -f "$file" ]] || { echo "error: required file missing: $file" >&2; exit 1; }
done

grep -q '^// swift-tools-version: 6\.2$' Package.swift || { echo "error: Package.swift must require Swift tools 6.2" >&2; exit 1; }
grep -q '\.macOS(\.v26)' Package.swift || { echo "error: Package.swift must target macOS 26" >&2; exit 1; }
grep -q '\.defaultIsolation(MainActor\.self)' Package.swift || { echo "error: missing MainActor default isolation" >&2; exit 1; }
grep -q 'InferIsolatedConformances' Package.swift || { echo "error: missing InferIsolatedConformances" >&2; exit 1; }
grep -q 'NonisolatedNonsendingByDefault' Package.swift || { echo "error: missing NonisolatedNonsendingByDefault" >&2; exit 1; }
grep -A1 '<key>LSMinimumSystemVersion</key>' Resources/Info.plist | grep -q '<string>26\.0</string>' || {
  echo "error: Info.plist must require macOS 26.0" >&2
  exit 1
}

[[ ! -e project.yml ]] || { echo "error: project.yml is not part of the SwiftPM-only template" >&2; exit 1; }
[[ ! -e Brewfile ]] || { echo "error: Homebrew is not part of the build contract" >&2; exit 1; }
if find .github/workflows -maxdepth 1 -type f \( -name '*.yml' -o -name '*.yaml' \) | grep -q .; then
  echo "error: GitHub Actions must remain permanently disabled; keep examples as *.disabled" >&2
  exit 1
fi

app_entry_count="$(find Sources/Application -type f -name '*App.swift' -print | awk 'END { print NR }')"
[[ "$app_entry_count" -eq 1 ]] || {
  echo "error: expected one Sources/Application/*App.swift entry point" >&2
  exit 1
}

while IFS= read -r script; do bash -n "$script"; done < <(find scripts -type f -name '*.sh' -print)
./scripts/check-skills.sh

for target in build package-build test check release-check workflow-test run install register dist rename; do
  grep -q "^$target:" Makefile || { echo "error: missing Makefile target: $target" >&2; exit 1; }
done

grep -q '^release-check: validate workflow-test lint test package-build$' Makefile || {
  echo "error: release-check must run the complete automated distribution preflight" >&2
  exit 1
}
grep -q '^release-check: CONFIGURATION := release$' Makefile || {
  echo "error: release-check must compile the release configuration" >&2
  exit 1
}
grep -q 'shasum -a 256 -c' scripts/release-macos.sh || {
  echo "error: release workflow must verify the final downloaded-asset checksum format" >&2
  exit 1
}

if grep -RInE 'xcodegen|xcodebuild|\.xcodeproj|build-(ios|catalyst|tvos|visionos|watchos)|bootstrap-all|build-all' \
  --exclude-dir=.git --exclude='*.disabled' --exclude='static-checks.sh' \
  --exclude='test-make-workflows.sh' --exclude='README.md' --exclude='AGENTS.md' \
  --exclude='NOTICE.md' --exclude='RELEASE.md' --exclude='SKILL.md' .; then
  echo "error: stale Xcode project or premature platform-build reference found" >&2
  exit 1
fi

if grep -RInE '[[:blank:]]+$' --exclude-dir=.git --exclude-dir=.build --exclude='*.png' .; then
  echo "error: trailing whitespace found" >&2
  exit 1
fi

if grep -RInE '(API_KEY|SECRET|TOKEN|PASSWORD)[[:space:]]*=[[:space:]]*[^$[:space:]]+' \
  --include='*.swift' --include='*.sh' --include='*.yml' --include='*.yaml' .; then
  echo "error: possible committed secret found" >&2
  exit 1
fi

while IFS= read -r -d '' json; do
  if command -v jq >/dev/null 2>&1; then jq -e . "$json" >/dev/null; fi
done < <(find Resources -name '*.json' -type f -print0)
if command -v plutil >/dev/null 2>&1; then plutil -lint Resources/Info.plist Config/Starter.entitlements >/dev/null; fi

echo "Static checks passed (SwiftPM topology, syntax, whitespace, secrets, resources)."
