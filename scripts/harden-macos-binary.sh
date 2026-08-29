#!/usr/bin/env bash
set -euo pipefail

[[ "$(uname -s)" == "Darwin" ]] || { echo "error: Mach-O hardening requires macOS" >&2; exit 1; }

executable="${1:?usage: harden-macos-binary.sh EXECUTABLE DSYM_PATH}"
dsym_path="${2:?usage: harden-macos-binary.sh EXECUTABLE DSYM_PATH}"

[[ -f "$executable" && -x "$executable" ]] || {
  echo "error: executable not found at $executable" >&2
  exit 1
}
[[ "$dsym_path" == *.dSYM ]] || {
  echo "error: private symbol output must end in .dSYM" >&2
  exit 64
}

rm -rf "$dsym_path"
mkdir -p "$(dirname "$dsym_path")"
xcrun dsymutil "$executable" -o "$dsym_path"

binary_uuids="$(dwarfdump --uuid "$executable" | awk '{ print $2 }' | sort)"
dsym_uuids="$(dwarfdump --uuid "$dsym_path" | awk '{ print $2 }' | sort)"
[[ -n "$binary_uuids" && "$binary_uuids" == "$dsym_uuids" ]] || {
  echo "error: dSYM UUIDs do not match $executable" >&2
  exit 1
}

# Remove source/debug entries, local names, Swift nlist symbols, and the nlist
# string table. Dyld-required exports and Swift runtime metadata remain intact.
xcrun strip -S -x -T -N -no_code_signature_warning "$executable"

symbol_count="$(otool -l "$executable" | awk '
  /cmd LC_SYMTAB/ { in_symtab = 1; next }
  in_symtab && /nsyms/ { print $2; in_symtab = 0 }
')"
[[ "$symbol_count" == "0" ]] || {
  echo "error: expected an empty Mach-O nlist symbol table in $executable" >&2
  exit 1
}

if otool -l "$executable" | grep -E '__DWARF|__debug_' >/dev/null; then
  echo "error: debug sections remain in $executable" >&2
  exit 1
fi

printf 'Hardened %s; private symbols are in %s\n' "$executable" "$dsym_path"
