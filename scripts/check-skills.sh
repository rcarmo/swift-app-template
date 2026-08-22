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

  agent_file="${skill_dir%/}/agents/openai.yaml"
  [[ -f "$agent_file" ]] || { echo "error: missing $agent_file" >&2; exit 1; }
  grep -q '^interface:$' "$agent_file" || { echo "error: missing interface metadata: $agent_file" >&2; exit 1; }
  grep -q '^  display_name: "[^"]\+"$' "$agent_file" || {
    echo "error: missing quoted display_name: $agent_file" >&2
    exit 1
  }
  short_description="$(sed -n 's/^  short_description: "\(.*\)"$/\1/p' "$agent_file")"
  [[ "${#short_description}" -ge 25 && "${#short_description}" -le 64 ]] || {
    echo "error: short_description must contain 25-64 characters: $agent_file" >&2
    exit 1
  }
  grep -Fq "default_prompt: \"Use \$$expected_name" "$agent_file" || {
    echo "error: default_prompt must invoke \$$expected_name: $agent_file" >&2
    exit 1
  }

  while IFS= read -r reference; do
    [[ -f "${skill_dir%/}/$reference" ]] || {
      echo "error: missing referenced resource ${skill_dir%/}/$reference" >&2
      exit 1
    }
  done < <(grep -oE 'references/[A-Za-z0-9._-]+\.md' "$skill_file" | sort -u)

  for reference_file in "${skill_dir%/}"/references/*.md; do
    [[ -e "$reference_file" ]] || continue
    reference_name="$(basename "$reference_file")"
    grep -Fq "$reference_name" "$skill_file" || {
      echo "error: unrouted reference $reference_file" >&2
      exit 1
    }
  done

  while IFS= read -r related_skill; do
    [[ -f "${skill_dir%/}/$related_skill" ]] || {
      echo "error: missing related skill ${skill_dir%/}/$related_skill" >&2
      exit 1
    }
  done < <(grep -oE '\.\./[A-Za-z0-9._-]+/SKILL\.md' "$skill_file" | sort -u)
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
