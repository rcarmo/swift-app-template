#!/usr/bin/env bash
set -euo pipefail

[[ "$(uname -s)" == "Darwin" ]] || { echo "error: icon generation requires macOS sips and iconutil" >&2; exit 1; }
source_png="${1:-}"
[[ -f "$source_png" ]] || { echo "usage: $0 path/to/1024x1024.png" >&2; exit 64; }

pixels="$(sips -g pixelWidth -g pixelHeight "$source_png" | awk '/pixelWidth|pixelHeight/ { print $2 }' | paste -sd x -)"
[[ "$pixels" == "1024x1024" ]] || { echo "error: source icon must be 1024x1024 pixels (found $pixels)" >&2; exit 1; }

iconset="build/AppIcon.iconset"
assetset="Resources/Assets.xcassets/AppIcon.appiconset"
rm -rf "$iconset" "$assetset"
mkdir -p "$iconset" "$assetset"

for spec in "16 icon_16x16.png" "32 icon_16x16@2x.png" "32 icon_32x32.png" \
  "64 icon_32x32@2x.png" "128 icon_128x128.png" "256 icon_128x128@2x.png" \
  "256 icon_256x256.png" "512 icon_256x256@2x.png" "512 icon_512x512.png" \
  "1024 icon_512x512@2x.png"; do
  read -r size filename <<< "$spec"
  sips -z "$size" "$size" "$source_png" --out "$iconset/$filename" >/dev/null
  cp "$iconset/$filename" "$assetset/$filename"
done
iconutil -c icns "$iconset" -o build/AppIcon.icns
cp "$source_png" "$assetset/AppIcon-1024.png"
cat > "$assetset/Contents.json" <<'JSON'
{
  "images": [
    { "filename": "AppIcon-1024.png", "idiom": "universal", "platform": "ios", "size": "1024x1024" },
    { "filename": "icon_16x16.png", "idiom": "mac", "scale": "1x", "size": "16x16" },
    { "filename": "icon_16x16@2x.png", "idiom": "mac", "scale": "2x", "size": "16x16" },
    { "filename": "icon_32x32.png", "idiom": "mac", "scale": "1x", "size": "32x32" },
    { "filename": "icon_32x32@2x.png", "idiom": "mac", "scale": "2x", "size": "32x32" },
    { "filename": "icon_128x128.png", "idiom": "mac", "scale": "1x", "size": "128x128" },
    { "filename": "icon_128x128@2x.png", "idiom": "mac", "scale": "2x", "size": "128x128" },
    { "filename": "icon_256x256.png", "idiom": "mac", "scale": "1x", "size": "256x256" },
    { "filename": "icon_256x256@2x.png", "idiom": "mac", "scale": "2x", "size": "256x256" },
    { "filename": "icon_512x512.png", "idiom": "mac", "scale": "1x", "size": "512x512" },
    { "filename": "icon_512x512@2x.png", "idiom": "mac", "scale": "2x", "size": "512x512" }
  ],
  "info": { "author": "xcode", "version": 1 }
}
JSON
echo "Created iOS/macOS AppIcon assets and build/AppIcon.icns"
