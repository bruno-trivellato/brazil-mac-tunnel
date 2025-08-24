#!/bin/bash

# Creates intelligent Brazil SSH Tunnel app

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="🇧🇷 Brazil SSH Tunnel"
APP_PATH="${PROJECT_DIR}/${APP_NAME}.app"

# Remove existing app
rm -rf "${APP_PATH}"

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
    <string>${APP_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>com.user.brazil-ssh-tunnel-setup</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleIconFile</key>
    <string>icon</string>
</dict>
</plist>
EOF

# Create the executable script that uses our smart start script
cat > "${APP_PATH}/Contents/MacOS/${APP_NAME}" << 'EOF'
#!/bin/bash

PROJECT_DIR="/Users/bruno.trivellato/Downloads/config_ssh_tunnel"

# Check if project exists
if [[ ! -d "$PROJECT_DIR" ]]; then
    osascript -e 'display dialog "Brazil SSH Tunnel project not found at:\n/Users/bruno.trivellato/Downloads/config_ssh_tunnel\n\nPlease download the project first." with title "Setup Required" buttons {"OK"} default button "OK"'
    exit 1
fi

# Check if start script exists
if [[ ! -f "$PROJECT_DIR/start" ]]; then
    osascript -e 'display dialog "Start script not found. Please check the project installation." with title "Setup Error" buttons {"OK"} default button "OK"'
    exit 1
fi

# Show welcome dialog
RESPONSE=$(osascript << 'APPLESCRIPT'
display dialog "🇧🇷 Welcome to Brazil SSH Tunnel Setup!

This app will guide you through setting up a secure tunnel to access Brazilian content from anywhere in the world.

What would you like to do?" with title "Brazil SSH Tunnel" buttons {"Setup Guide", "Quick Start", "Cancel"} default button "Quick Start"
button returned of result
APPLESCRIPT
)

case "$RESPONSE" in
    "Quick Start")
        # Run the smart start script in Terminal
        osascript << APPLESCRIPT
tell application "Terminal"
    if not (exists window 1) then
        activate
        do script "cd '$PROJECT_DIR' && ./start"
    else
        activate
        tell window 1
            do script "cd '$PROJECT_DIR' && ./start" in selected tab
        end tell
    end if
    set custom title of front tab of front window to "🇧🇷 Brazil Tunnel Setup"
end tell
APPLESCRIPT
        ;;
    "Setup Guide")
        # Show setup options
        GUIDE_RESPONSE=$(osascript << 'APPLESCRIPT'
display dialog "Choose a setup guide to open:

• Azure VM Setup: Create your Brazil server
• SSH Keys: Generate secure authentication  
• Browser Setup: Configure Firefox/Chrome
• Android Setup: Mobile tunnel access" with title "Setup Guides" buttons {"Azure VM", "SSH Keys", "Browser", "Cancel"} default button "Azure VM"
button returned of result
APPLESCRIPT
        )
        
        case "$GUIDE_RESPONSE" in
            "Azure VM")
                open "$PROJECT_DIR/docs/azure_vm_setup.md"
                ;;
            "SSH Keys")
                open "$PROJECT_DIR/docs/ssh_key_setup.md"
                ;;
            "Browser")
                open "$PROJECT_DIR/docs/foxyproxy_setup.md"
                ;;
        esac
        ;;
    "Cancel")
        exit 0
        ;;
esac
EOF

# Make it executable
chmod +x "${APP_PATH}/Contents/MacOS/${APP_NAME}"

# Download Brazil flag for manual icon setting
echo "🇧🇷 Preparing Brazil flag icon..."
if command -v curl >/dev/null 2>&1; then
    if curl -L "https://flagcdn.com/256x192/br.png" -o "$HOME/Desktop/brazil_flag.png" 2>/dev/null; then
        echo "✅ Downloaded Brazil flag to Desktop"
        echo "💡 To set as app icon:"
        echo "   1. Copy brazil_flag.png from Desktop (Cmd+C)"
        echo "   2. Right-click app → Get Info"
        echo "   3. Click small icon in top-left"
        echo "   4. Paste (Cmd+V)"
    else
        echo "⚠️  Failed to download flag"
    fi
else
    echo "⚠️  curl not found"
fi

echo "📖 For detailed instructions: open tools/manual_icon_setup.md"

# Set Brazil theme color and force icon refresh
osascript << APPLESCRIPT
set appPath to POSIX file "${APP_PATH}" as alias
tell application "Finder"
    set the label index of appPath to 6
    set comment of appPath to "🇧🇷 Smart setup assistant for Brazil SSH tunnel"
end tell
APPLESCRIPT

# Force Finder to refresh the icon cache
touch "${APP_PATH}"

echo "✅ Created intelligent setup app: ${APP_PATH}"
echo "🎯 Features:"
echo "   • Smart configuration wizard"
echo "   • Automatic problem detection"
echo "   • Step-by-step guidance"
echo "   • One-click tunnel start"
echo ""
echo "📱 Double-click the app to start setup!"