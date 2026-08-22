#!/usr/bin/env bash
set -euo pipefail

[[ "$(uname -s)" == "Darwin" ]] || { echo "error: release requires macOS" >&2; exit 1; }
: "${CERT_NAME:?Set CERT_NAME to a Developer ID Application identity}"
: "${TEAM_ID:?Set TEAM_ID to the Apple Developer team identifier}"
: "${NOTARY_PROFILE:?Set NOTARY_PROFILE to a notarytool keychain profile}"

app_name="${APP_NAME:-Starter}"
version="${VERSION:-$(head -n 1 VERSION)}"
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+([.-][A-Za-z0-9.-]+)?$ ]] || {
  echo "error: VERSION must begin with a semantic X.Y.Z version" >&2
  exit 64
}
dist_dir="${DIST_DIR:-dist}"
derived_data="build/DerivedData"
app="$derived_data/Build/Products/Release/$app_name.app"
notary_zip="$dist_dir/$app_name-$version-notary.zip"
release_zip="$dist_dir/$app_name-$version-macos.zip"

rm -rf build "$dist_dir"
mkdir -p "$dist_dir"
xcodebuild build \
  -project "$app_name.xcodeproj" \
  -scheme "$app_name-macOS" \
  -configuration Release \
  -destination 'platform=macOS' \
  -derivedDataPath "$derived_data" \
  MARKETING_VERSION="$version" \
  CODE_SIGN_STYLE=Manual \
  DEVELOPMENT_TEAM="$TEAM_ID" \
  CODE_SIGN_IDENTITY="$CERT_NAME" \
  OTHER_CODE_SIGN_FLAGS='--timestamp'

codesign --verify --deep --strict --verbose=2 "$app"
ditto -c -k --keepParent "$app" "$notary_zip"
xcrun notarytool submit "$notary_zip" --keychain-profile "$NOTARY_PROFILE" --wait
xcrun stapler staple "$app"
xcrun stapler validate "$app"
spctl --assess --type execute --verbose=2 "$app"

ditto -c -k --keepParent "$app" "$release_zip"
shasum -a 256 "$release_zip" > "$release_zip.sha256"
rm -f "$notary_zip"
echo "Created $release_zip and $release_zip.sha256"
