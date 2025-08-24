#!/bin/bash

# Simple way to add Brazil flag emoji as icon using SF Symbols approach
APP_PATH="$HOME/Desktop/Brazil SSH Tunnel.app"

# Update Info.plist to include icon
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
    <key>LSUIElement</key>
    <false/>
</dict>
</plist>
EOF

# Set custom icon using Finder
osascript << 'APPLESCRIPT'
set appPath to (path to home folder as string) & "Desktop:Brazil SSH Tunnel.app"
tell application "Finder"
    set the label index of file appPath to 6
end tell
APPLESCRIPT

echo "✅ Updated app with Brazil theme!"