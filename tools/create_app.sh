#!/bin/bash

APP_NAME="Brazil SSH Tunnel"
APP_PATH="$HOME/Desktop/${APP_NAME}.app"
SCRIPT_PATH="/Users/bruno.trivellato/Downloads/config_ssh_tunnel/ssh_tunnel.sh"

# Create the .app structure
mkdir -p "${APP_PATH}/Contents/MacOS"
mkdir -p "${APP_PATH}/Contents/Resources"

# Create Info.plist
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
    <string>Brazil SSH Tunnel</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
</dict>
</plist>
EOF

# Create the executable script
cat > "${APP_PATH}/Contents/MacOS/Brazil SSH Tunnel" << 'EOF'
#!/bin/bash

# Get the directory where this app is located
APP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_DIR="/Users/bruno.trivellato/Downloads/config_ssh_tunnel"

# Open Terminal and run the SSH tunnel script
osascript << APPLESCRIPT
tell application "Terminal"
    activate
    set newTab to do script "cd '$SCRIPT_DIR' && ./ssh_tunnel.sh"
    set custom title of newTab to "🇧🇷 Brazil SSH Tunnel"
end tell
APPLESCRIPT
EOF

# Make it executable
chmod +x "${APP_PATH}/Contents/MacOS/Brazil SSH Tunnel"

echo "✅ Created app: ${APP_PATH}"
echo "📱 Drag it to your Dock from Desktop!"
echo "🔥 Double-click to start your Brazil tunnel"