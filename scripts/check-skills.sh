#!/usr/bin/env bash
set -euo pipefail

skills_root=".pi/skills"
[[ -f "$skills_root/README.md" ]] || { echo "error: missing local skill index" >&2; exit 1; }

required_skills="apple-accessibility apple-design-review apple-localization apple-privacy-security apple-project-workflows apple-release apple-typography swift-architecture swift-concurrency swift-style-tooling swift-testing swiftui-hardening swiftui-implementation swiftui-navigation swiftui-performance"
for required_skill in $required_skills; do
  [[ -f "$skills_root/$required_skill/SKILL.md" ]] || {
    echo "error: missing required local skill: $required_skill" >&2
    exit 1
  }
done

skill_count=0
for skill_dir in "$skills_root"/*/; do
  [[ -d "$skill_dir" ]] || continue
  skill_file="${skill_dir%/}/SKILL.md"
  expected_name="$(basename "${skill_dir%/}")"
  [[ -f "$skill_file" ]] || { echo "error: missing $skill_file" >&2; exit 1; }

  skill_count=$((skill_count + 1))
  first_line="$(sed -n '1p' "$skill_file")"
  name="$(sed -n 's/^name:[[:space:]]*//p' "$skill_file" | head -n 1)"

  [[ "$first_line" == "---" ]] || { echo "error: missing YAML frontmatter: $skill_file" >&2; exit 1; }
  [[ "$name" == "$expected_name" ]] || {
    echo "error: skill name '$name' does not match directory '$expected_name'" >&2
    exit 1
  }
  grep -q '^description:[[:space:]]*[^[:space:]]' "$skill_file" || {
    echo "error: missing skill description: $skill_file" >&2
    exit 1
  }
  grep -q '^license:[[:space:]]*[^[:space:]]' "$skill_file" || {
    echo "error: missing skill license: $skill_file" >&2
    exit 1
  }
  grep -q '^metadata:' "$skill_file" || {
    echo "error: missing skill metadata: $skill_file" >&2
    exit 1
  }
  grep -q '^  provenance:[[:space:]]*[^[:space:]]' "$skill_file" || {
    echo "error: missing skill provenance: $skill_file" >&2
    exit 1
  }
done

[[ "$skill_count" -eq 15 ]] || {
  echo "error: expected exactly 15 local functional skills; found $skill_count" >&2
  exit 1
}

if grep -RIn '/workspace/tmp/swift-app-template-sources' "$skills_root"; then
  echo "error: local skills must not depend on audited temporary source paths" >&2
  exit 1
fi

echo "Skill checks passed ($skill_count local functional skills)."
