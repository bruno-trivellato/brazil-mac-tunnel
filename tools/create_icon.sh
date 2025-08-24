#!/bin/bash

# Create proper macOS icon from Brazil flag

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_PATH="${PROJECT_DIR}/🇧🇷 Brazil SSH Tunnel.app"
ICON_DIR="${APP_PATH}/Contents/Resources"

echo "🇧🇷 Creating Brazil flag icon..."

# Download Brazil flag
TEMP_PNG="/tmp/brazil_flag_$(date +%s).png"
if curl -L "https://flagcdn.com/512x384/br.png" -o "$TEMP_PNG" 2>/dev/null; then
    echo "✅ Downloaded Brazil flag"
else
    echo "❌ Failed to download flag"
    exit 1
fi

# Create iconset directory
ICONSET_DIR="/tmp/BrazilFlag.iconset"
rm -rf "$ICONSET_DIR"
mkdir -p "$ICONSET_DIR"

# Create different sizes for iconset
echo "🔧 Creating icon sizes..."

# Standard sizes for macOS icons
declare -a sizes=("16" "32" "64" "128" "256" "512" "1024")
declare -a names=("icon_16x16.png" "icon_16x16@2x.png" "icon_32x32.png" "icon_32x32@2x.png" "icon_64x64.png" "icon_128x128.png" "icon_128x128@2x.png" "icon_256x256.png" "icon_256x256@2x.png" "icon_512x512.png" "icon_512x512@2x.png")

# Generate all required sizes
sips -z 16 16 "$TEMP_PNG" --out "$ICONSET_DIR/icon_16x16.png" >/dev/null 2>&1
sips -z 32 32 "$TEMP_PNG" --out "$ICONSET_DIR/icon_16x16@2x.png" >/dev/null 2>&1
sips -z 32 32 "$TEMP_PNG" --out "$ICONSET_DIR/icon_32x32.png" >/dev/null 2>&1
sips -z 64 64 "$TEMP_PNG" --out "$ICONSET_DIR/icon_32x32@2x.png" >/dev/null 2>&1
sips -z 128 128 "$TEMP_PNG" --out "$ICONSET_DIR/icon_128x128.png" >/dev/null 2>&1
sips -z 256 256 "$TEMP_PNG" --out "$ICONSET_DIR/icon_128x128@2x.png" >/dev/null 2>&1
sips -z 256 256 "$TEMP_PNG" --out "$ICONSET_DIR/icon_256x256.png" >/dev/null 2>&1
sips -z 512 512 "$TEMP_PNG" --out "$ICONSET_DIR/icon_256x256@2x.png" >/dev/null 2>&1
sips -z 512 512 "$TEMP_PNG" --out "$ICONSET_DIR/icon_512x512.png" >/dev/null 2>&1
sips -z 1024 1024 "$TEMP_PNG" --out "$ICONSET_DIR/icon_512x512@2x.png" >/dev/null 2>&1

echo "✅ Created icon sizes"

# Convert iconset to icns
if iconutil -c icns "$ICONSET_DIR" -o "$ICON_DIR/icon.icns" 2>/dev/null; then
    echo "✅ Created ICNS file"
else
    echo "❌ iconutil failed, trying alternative..."
    # Fallback: just copy the 512x512 version as icns
    cp "$ICONSET_DIR/icon_512x512.png" "$ICON_DIR/icon.icns"
fi

# Clean up
rm -rf "$ICONSET_DIR" "$TEMP_PNG"

# Force icon refresh
touch "$APP_PATH"
echo "🔄 Refreshing icon cache..."

# Try to refresh icon using Finder
osascript << 'APPLESCRIPT' 2>/dev/null || true
tell application "Finder"
    update every item of desktop
end tell
APPLESCRIPT

echo "✅ Icon creation complete!"
echo "💡 If icon doesn't appear immediately:"
echo "   • Restart Finder: killall Finder"
echo "   • Move app to another folder and back"
echo "   • Get Info on app (Cmd+I) and close"