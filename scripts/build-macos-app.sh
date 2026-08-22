#!/usr/bin/env bash
set -euo pipefail

[[ "$(uname -s)" == "Darwin" ]] || { echo "error: macOS app bundling requires macOS" >&2; exit 1; }

configuration="${CONFIGURATION:-debug}"
app_name="${APP_NAME:-Starter}"
product_name="${PRODUCT_NAME:-Starter}"
bundle_id="${BUNDLE_ID:-com.example.starter}"
version="${VERSION:-$(head -n 1 VERSION)}"
build_number="${BUILD_NUMBER:-$(date -u +%Y%m%d%H%M)}"
sign_identity="${SIGN_IDENTITY:--}"
output_dir="${OUTPUT_DIR:-build}"
app="$output_dir/$app_name.app"
info_plist="${INFO_PLIST:-Resources/Info.plist}"
entitlements="${ENTITLEMENTS:-Config/$app_name.entitlements}"
icon="${APP_ICON:-build/AppIcon.icns}"

[[ "$configuration" == "debug" || "$configuration" == "release" ]] || {
  echo "error: CONFIGURATION must be debug or release" >&2
  exit 64
}
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+([.-][A-Za-z0-9.-]+)?$ ]] || {
  echo "error: VERSION must begin with a semantic X.Y.Z version" >&2
  exit 64
}
[[ -f "$info_plist" ]] || { echo "error: missing $info_plist" >&2; exit 1; }
[[ -f "$entitlements" ]] || { echo "error: missing $entitlements" >&2; exit 1; }

swift build --product "$product_name" --configuration "$configuration"
bin_path="$(swift build --product "$product_name" --configuration "$configuration" --show-bin-path)"
executable="$bin_path/$product_name"
[[ -x "$executable" ]] || { echo "error: executable not found at $executable" >&2; exit 1; }

rm -rf "$app"
mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
cp "$executable" "$app/Contents/MacOS/$app_name"
sed \
  -e "s|<string>Starter</string>|<string>$app_name</string>|g" \
  -e "s|<string>com.example.starter</string>|<string>$bundle_id</string>|g" \
  -e "s|__SHORT_VERSION__|$version|g" \
  -e "s|__BUILD_VERSION__|$build_number|g" \
  "$info_plist" > "$app/Contents/Info.plist"
printf 'APPL????' > "$app/Contents/PkgInfo"

for bundle in "$bin_path"/*.bundle; do
  [[ -e "$bundle" ]] || continue
  cp -R "$bundle" "$app/Contents/Resources/"
done
if [[ -f "$icon" ]]; then
  cp "$icon" "$app/Contents/Resources/AppIcon.icns"
fi

codesign --force --sign "$sign_identity" --entitlements "$entitlements" "$app"
codesign --verify --strict --verbose=2 "$app"
plutil -lint "$app/Contents/Info.plist" >/dev/null
printf 'Created %s\n' "$app"
