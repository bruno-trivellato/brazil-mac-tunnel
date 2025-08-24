#!/bin/bash

APP_PATH="$HOME/Desktop/Brazil SSH Tunnel.app"

# Update Info.plist to reference the icon
cat > "${APP_PATH}/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>Brazil SSH Tunnel</string>
    <key>CFBundleIdentifier</key>
    <string>com.user.brazil-ssh-tunnel</string>
    <key>CFBundleName</key>
    <string>🇧🇷 Brazil SSH</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleIconFile</key>
    <string>icon</string>
    <key>LSUIElement</key>
    <false/>
</dict>
</plist>
EOF

# Create a simple Brazil flag icon using SF Symbols and emoji
# Since we can't easily create .icns files, let's use a different approach
# We'll create a custom icon using the emoji in the app name and folder color

# Set the folder to have a custom color (green for Brazil theme)
osascript << 'APPLESCRIPT'
set appPath to (path to home folder as string) & "Desktop:Brazil SSH Tunnel.app"
tell application "Finder"
    set the label index of file appPath to 6
    set comment of file appPath to "🇧🇷 SSH Tunnel to Brazil VM"
end tell
APPLESCRIPT

# Create a simple icon using ImageMagick if available, otherwise use text-based approach
if command -v convert >/dev/null 2>&1; then
    # Create a simple Brazil flag-colored icon
    convert -size 256x256 xc:"#009739" \
            -fill "#FEDD00" -draw "rectangle 0,85 256,171" \
            -fill "#002776" -draw "circle 128,128 128,90" \
            -fill white -pointsize 20 -gravity center -annotate +0+0 "SSH" \
            "${APP_PATH}/Contents/Resources/icon.png"
    
    # Convert to icns if possible
    if command -v png2icns >/dev/null 2>&1; then
        png2icns "${APP_PATH}/Contents/Resources/icon.icns" "${APP_PATH}/Contents/Resources/icon.png"
        rm "${APP_PATH}/Contents/Resources/icon.png"
    fi
fi

# Force Finder to refresh the icon
touch "${APP_PATH}"

echo "✅ Icon updated! You might need to:"
echo "1. Restart Finder: killall Finder"
echo "2. Or move the app and move it back to refresh the icon"
echo "🇧🇷 The Brazil flag theme should now appear!"