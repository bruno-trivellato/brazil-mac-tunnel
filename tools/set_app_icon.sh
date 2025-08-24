#!/bin/bash

# Set Brazil flag icon using the copy/paste method

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_PATH="${PROJECT_DIR}/🇧🇷 Brazil SSH Tunnel.app"

echo "🇧🇷 Setting Brazil flag icon using Finder method..."

# Download Brazil flag to Desktop for easy access
ICON_FILE="$HOME/Desktop/brazil_flag_icon.png"
if curl -L "https://flagcdn.com/256x192/br.png" -o "$ICON_FILE" 2>/dev/null; then
    echo "✅ Downloaded Brazil flag to Desktop"
    
    # Use AppleScript to set the icon
    osascript << APPLESCRIPT
tell application "Finder"
    -- Open the flag image
    set flagFile to POSIX file "$ICON_FILE" as alias
    
    -- Get the app file
    set appFile to POSIX file "$APP_PATH" as alias
    
    -- Copy the image
    open flagFile
    delay 1
    tell application "Preview"
        activate
        tell application "System Events"
            keystroke "a" using command down -- Select all
            keystroke "c" using command down -- Copy
        end tell
        quit
    end tell
    
    delay 1
    
    -- Open app info and paste icon
    open information window of appFile
    delay 2
    
    tell application "System Events"
        tell window 1 of application process "Finder"
            -- Click on the icon in the info window
            click image 1
            delay 1
            -- Paste the copied image
            keystroke "v" using command down
        end tell
    end tell
    
    delay 2
    close information window of appFile
    
end tell
APPLESCRIPT
    
    # Clean up
    rm -f "$ICON_FILE"
    
    echo "✅ Icon set successfully!"
    echo "🔄 The Brazil flag should now appear as the app icon"
    
else
    echo "❌ Failed to download Brazil flag"
    echo "💡 Manual method:"
    echo "1. Download Brazil flag from: https://flagcdn.com/256x192/br.png"
    echo "2. Right-click app → Get Info"
    echo "3. Click small icon in top-left of info window"
    echo "4. Paste (Cmd+V) the flag image"
fi