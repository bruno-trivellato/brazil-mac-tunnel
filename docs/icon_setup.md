# Brazil Flag Icon Setup 🇧🇷

Make your tunnel app look amazing with a proper Brazil flag icon!

## Quick Method (Copy & Paste)

### 1. Download Brazil Flag Image

Right-click and save this Brazil flag image:
![Brazil Flag](https://flagcdn.com/256x192/br.png)

Or download from: https://flagcdn.com/256x192/br.png

### 2. Set App Icon (Finder Method)

1. **Copy the flag image** (Cmd+C)
2. **Find your app**: `Brazil SSH Tunnel.app` on Desktop
3. **Right-click** → **"Get Info"**
4. **Click the small icon** in top-left corner of Info window
5. **Paste** (Cmd+V)
6. ✅ **Done!** Icon should change immediately

## Alternative Methods

### Method A: Download & Convert

```bash
# Download Brazil flag
curl -L "https://flagcdn.com/256x192/br.png" -o /tmp/brazil_flag.png

# Convert to macOS icon format
sips -z 1024 1024 /tmp/brazil_flag.png --out /tmp/brazil_icon.png

# Manual: Copy /tmp/brazil_icon.png and paste on app icon in Finder
```

### Method B: Use SF Symbols

1. Open **SF Symbols** app (pre-installed on macOS)
2. Search for "flag" or "globe"
3. Export a globe/world icon
4. Use copy/paste method above

### Method C: Online Icon Converter

1. Visit **iConvert Icons** or **CloudConvert**
2. Upload Brazil flag image (PNG/JPG)
3. Convert to `.icns` format
4. Replace `Brazil SSH Tunnel.app/Contents/Resources/icon.icns`

## Advanced: Script-Based Setup

Use the included tool to set up the icon automatically:

```bash
# From project root
./tools/fix_icon.sh
```

This script:
- Downloads Brazil flag automatically
- Converts to proper icon format
- Applies to your app
- Sets green folder color theme

## Troubleshooting

### Icon Won't Change?
1. **Restart Finder**: Press `Cmd+Option+Esc` → Force quit Finder
2. **Move the app** to another folder and back
3. **Clear icon cache**: `sudo rm -rf /Library/Caches/com.apple.iconservices.store`

### Can't Find SF Symbols App?
```bash
# Check if installed
ls /System/Applications/SF\ Symbols.app

# Download from Apple Developer (free)
# https://developer.apple.com/sf-symbols/
```

### Permission Issues?
```bash
# Make sure you own the app
sudo chown -R $(whoami) "Brazil SSH Tunnel.app"

# Check app permissions
ls -la "Brazil SSH Tunnel.app"
```

## Brazil Flag Resources

### Free Flag Sources:
- **Flagcdn**: https://flagcdn.com/br.svg (vector)
- **Flagpedia**: https://flagpedia.net/brazil (various sizes)
- **Wikipedia**: https://upload.wikimedia.org/wikipedia/en/0/05/Flag_of_Brazil.svg
- **Country Flags**: https://countryflagsapi.com/png/br

### Icon Specifications:
- **Size**: 256x256 minimum, 1024x1024 recommended
- **Format**: PNG, ICNS (macOS preferred)
- **Style**: Clean, high contrast
- **Background**: Transparent or white

## Visual Result

After setup, your Dock should show:
- 🇧🇷 **Brazil flag icon** for the app
- **"🇧🇷 Brazil SSH Tunnel"** name
- **Green label** (Brazil theme color)

Perfect for quick identification! 🚀

---

✅ **Next:** Smart setup app → [Intelligent Setup Guide](setup_assistant.md)