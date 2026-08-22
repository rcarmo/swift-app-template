#!/usr/bin/env bash
set -euo pipefail

required=(Package.swift project.yml Makefile Brewfile README.md NOTICE.md AGENTS.md \
  Sources/AppCore/Application/AppModel.swift .github/workflows/ci.yml.disabled \
  .github/workflows/release.yml .github/workflows/prune-actions-artifacts.yml)
for file in "${required[@]}"; do
  [[ -f "$file" ]] || { echo "error: required file missing: $file" >&2; exit 1; }
done

app_entry_count="$(find Sources/Application -type f -name '*App.swift' -print | awk 'END { print NR }')"
[[ "$app_entry_count" -eq 1 ]] || {
  echo "error: expected one Sources/Application/*App.swift entry point" >&2
  exit 1
}

while IFS= read -r script; do bash -n "$script"; done < <(find scripts -type f -name '*.sh' -print)
./scripts/check-skills.sh

for target in bootstrap bootstrap-all build build-all workflow-test build-ios build-catalyst build-macos \
  build-tvos build-visionos build-watchos; do
  grep -q "^$target:" Makefile || { echo "error: missing Makefile target: $target" >&2; exit 1; }
done

[[ ! -e .github/workflows/ci.yml ]] || {
  echo "error: CI must remain opt-in; preserve it as .github/workflows/ci.yml.disabled" >&2
  exit 1
}

if grep -RInE '[[:blank:]]+$' --exclude-dir=.git --exclude-dir=.build --exclude='*.png' .; then
  echo "error: trailing whitespace found" >&2
  exit 1
fi

if grep -RInE '(API_KEY|SECRET|TOKEN|PASSWORD)[[:space:]]*=[[:space:]]*[^$[:space:]]+' \
  --include='*.swift' --include='*.sh' --include='*.yml' --include='*.yaml' .; then
  echo "error: possible committed secret found" >&2
  exit 1
fi

for json in $(find Resources -name '*.json' -type f); do
  if command -v jq >/dev/null 2>&1; then jq -e . "$json" >/dev/null; fi
done

echo "Static checks passed (syntax, whitespace, secret patterns, JSON)."
