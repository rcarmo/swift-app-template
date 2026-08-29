#!/usr/bin/env bash
set -euo pipefail

[[ "$(uname -s)" == "Darwin" ]] || { echo "error: release requires macOS" >&2; exit 1; }
: "${CERT_NAME:?Set CERT_NAME to a Developer ID Application identity}"
: "${NOTARY_PROFILE:?Set NOTARY_PROFILE to a notarytool keychain profile}"

app_name="${APP_NAME:-Starter}"
product_name="${PRODUCT_NAME:-Starter}"
bundle_id="${BUNDLE_ID:-com.example.starter}"
version="${VERSION:-$(head -n 1 VERSION)}"
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+([.-][A-Za-z0-9.-]+)?$ ]] || {
  echo "error: VERSION must begin with a semantic X.Y.Z version" >&2
  exit 64
}
dist_dir="${DIST_DIR:-dist}"
app="build/$app_name.app"
notary_zip="$dist_dir/$app_name-$version-notary.zip"
release_zip="$dist_dir/$app_name-$version-macos.zip"

rm -rf build "$dist_dir"
mkdir -p "$dist_dir"
APP_NAME="$app_name" PRODUCT_NAME="$product_name" BUNDLE_ID="$bundle_id" \
  CONFIGURATION=release SIGN_IDENTITY="$CERT_NAME" VERSION="$version" \
  ./scripts/build-macos-app.sh

codesign --force --options runtime --timestamp --sign "$CERT_NAME" \
  --entitlements "Config/$app_name.entitlements" "$app"
codesign --verify --deep --strict --verbose=2 "$app"
./scripts/verify-macos-hardening.sh \
  "$app/Contents/MacOS/$app_name" "build/Symbols/$app_name.app.dSYM"
ditto -c -k --keepParent "$app" "$notary_zip"
xcrun notarytool submit "$notary_zip" --keychain-profile "$NOTARY_PROFILE" --wait
xcrun stapler staple "$app"
xcrun stapler validate "$app"
spctl --assess --type execute --verbose=2 "$app"

ditto -c -k --keepParent "$app" "$release_zip"
(
  cd "$dist_dir"
  shasum -a 256 "$(basename "$release_zip")" > "$(basename "$release_zip").sha256"
  shasum -a 256 -c "$(basename "$release_zip").sha256"
)
rm -f "$notary_zip"
echo "Created $release_zip and $release_zip.sha256"
