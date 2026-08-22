#!/usr/bin/env bash
set -euo pipefail

required=(Package.swift Makefile README.md NOTICE.md AGENTS.md VERSION Resources/Info.plist \
  Config/Starter.entitlements Sources/Application/StarterApp.swift \
  Sources/AppCore/Application/AppModel.swift scripts/build-macos-app.sh \
  .github/workflows/release.yml .github/workflows/prune-actions-artifacts.yml)
for file in "${required[@]}"; do
  [[ -f "$file" ]] || { echo "error: required file missing: $file" >&2; exit 1; }
done

[[ ! -e project.yml ]] || { echo "error: project.yml is not part of the SwiftPM-only template" >&2; exit 1; }
[[ ! -e Brewfile ]] || { echo "error: Homebrew is not part of the build contract" >&2; exit 1; }
if [[ -e .github/workflows/ci.yml && -e .github/workflows/ci.yml.disabled ]]; then
  echo "error: keep either the active or disabled CI workflow, not both" >&2
  exit 1
fi
if [[ ! -e .github/workflows/ci.yml && ! -e .github/workflows/ci.yml.disabled ]]; then
  echo "error: missing CI workflow template" >&2
  exit 1
fi

app_entry_count="$(find Sources/Application -type f -name '*App.swift' -print | awk 'END { print NR }')"
[[ "$app_entry_count" -eq 1 ]] || {
  echo "error: expected one Sources/Application/*App.swift entry point" >&2
  exit 1
}

while IFS= read -r script; do bash -n "$script"; done < <(find scripts -type f -name '*.sh' -print)
./scripts/check-skills.sh

for target in build package-build test check workflow-test run install dist rename; do
  grep -q "^$target:" Makefile || { echo "error: missing Makefile target: $target" >&2; exit 1; }
done

if grep -RInE 'xcodegen|xcodebuild|\.xcodeproj|build-(ios|catalyst|tvos|visionos|watchos)|bootstrap-all|build-all' \
  --exclude-dir=.git --exclude='ci.yml.disabled' --exclude='static-checks.sh' \
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
