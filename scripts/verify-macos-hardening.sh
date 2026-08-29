#!/usr/bin/env bash
set -euo pipefail

[[ "$(uname -s)" == "Darwin" ]] || { echo "error: Mach-O verification requires macOS" >&2; exit 1; }

executable="${1:?usage: verify-macos-hardening.sh EXECUTABLE [DSYM_PATH]}"
dsym_path="${2:-}"

[[ -f "$executable" && -x "$executable" ]] || {
  echo "error: executable not found at $executable" >&2
  exit 1
}

symbol_count="$(otool -l "$executable" | awk '
  /cmd LC_SYMTAB/ { in_symtab = 1; next }
  in_symtab && /nsyms/ { print $2; in_symtab = 0 }
')"
[[ "$symbol_count" == "0" ]] || {
  echo "error: Mach-O nlist symbol table is not empty in $executable" >&2
  exit 1
}

if otool -l "$executable" | grep -E '__DWARF|__debug_' >/dev/null; then
  echo "error: debug sections remain in $executable" >&2
  exit 1
fi

if [[ -n "$dsym_path" ]]; then
  [[ -d "$dsym_path" ]] || { echo "error: missing private dSYM at $dsym_path" >&2; exit 1; }
  binary_uuids="$(dwarfdump --uuid "$executable" | awk '{ print $2 }' | sort)"
  dsym_uuids="$(dwarfdump --uuid "$dsym_path" | awk '{ print $2 }' | sort)"
  [[ -n "$binary_uuids" && "$binary_uuids" == "$dsym_uuids" ]] || {
    echo "error: dSYM UUIDs do not match $executable" >&2
    exit 1
  }
fi

printf 'Verified release hardening for %s\n' "$executable"
