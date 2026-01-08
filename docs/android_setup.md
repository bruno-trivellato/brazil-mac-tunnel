# Android SSH Tunnel Setup 📱🇧🇷

## Method 1: SSH Tunnel App with Password (Easiest!) ⭐

**No file transfers needed - just install and connect!**

### Recommended Apps (both work great!):
- **[OpenTunnel](https://play.google.com/store/apps/details?id=com.opentunnel.app&hl=en)** by Rooster Kid - Simple UI, works perfectly ✅ (Verified working!)
- **SSH Tunnel** by Max Lv - Popular alternative with more features

### Setup:
1. **Install**: [OpenTunnel](https://play.google.com/store/apps/details?id=com.opentunnel.app&hl=en) or "SSH Tunnel" from Google Play Store
2. **Add Connection**:
   - **Name**: `Brazil Tunnel`
   - **Host**: `74.163.64.57`
   - **Port**: `22`
   - **Username**: `azureuser`
   - **Authentication**: `Password`
   - **Password**: `OEHOjAV164paindnoMEfQNPU`
   - **Local Port**: `8080`
   - **Tunnel Type**: `SOCKS5` (or just `SOCKS`)

3. **Tap "Connect"** - Should show "Connected" status ✅

### Configure Android WiFi Proxy:
1. **Open**: Settings → Connections → WiFi
2. **Long-press** your current WiFi network
3. **Tap**: "Modify network" or "Manage network settings"
4. **Tap**: "Advanced options"
5. **Set**:
   - **Proxy**: `Manual`
   - **Proxy hostname**: `localhost` (or `127.0.0.1`)
   - **Proxy port**: `8080`
6. **Save**

### Usage:
- **Start tunnel** in SSH Tunnel app whenever you need Brazil IP
- **No need to configure proxy again** - it's saved in WiFi settings
- Works for **all apps** on your phone! 📱

---

## Method 2: SSH Tunnel App with SSH Key (More Secure)

**Requires transferring SSH key from Mac via USB/ADB**

### Setup:
1. **Install**: [OpenTunnel](https://play.google.com/store/apps/details?id=com.opentunnel.app&hl=en) or "SSH Tunnel" from Google Play Store
2. **Transfer SSH key** from Mac:
   ```bash
   # On Mac, connect phone via USB and run:
   adb push ~/.ssh/id_lila_wordpress_br_rsa /sdcard/Download/brazil_tunnel_key
   ```
3. **Add Connection**:
   - **Name**: `Brazil Tunnel`
   - **Host**: `74.163.64.57`
   - **Port**: `22`
   - **Username**: `azureuser`
   - **Authentication**: `Private Key`
   - **Private Key**: Browse → Downloads → `brazil_tunnel_key`
   - **Local Port**: `8080`
   - **Tunnel Type**: `SOCKS5`

### Usage:
Same WiFi proxy configuration as Method 1 above.

---

## Method 3: Termux (Advanced)

**For power users who want full SSH control**

### Setup:
1. **Install Termux** from F-Droid (not Play Store)
2. **Install OpenSSH**: `pkg install openssh`
3. **Run tunnel with password**:
   ```bash
   ssh -D 8080 -C -N -4 azureuser@74.163.64.57
   # Enter password when prompted: OEHOjAV164paindnoMEfQNPU
   ```

### Browser Setup:
- **Firefox Mobile**: Install "Proxy Mobile" addon
- **Chrome**: Use system WiFi proxy settings above

---

## Testing Your Connection:

1. **Start tunnel** in SSH Tunnel app
2. **Open Chrome** on your phone
3. **Visit**: https://whatismyipaddress.com
4. **Should show**: `74.163.64.57` (Brazil 🇧🇷)

If you see a different IP, check:
- Tunnel is connected in SSH Tunnel app
- WiFi proxy is configured correctly
- Proxy hostname is `localhost` (not empty)

---

## Connection Details Summary:

### Password Authentication (Recommended for Mobile):
- **Server**: `74.163.64.57`
- **Username**: `azureuser`
- **Password**: `OEHOjAV164paindnoMEfQNPU`
- **Port**: `22` (SSH)
- **Local Port**: `8080` (SOCKS proxy)

### SSH Key Authentication (Alternative):
- **Server**: `74.163.64.57`
- **Username**: `azureuser`
- **Key File**: `~/.ssh/id_lila_wordpress_br_rsa`
- **Port**: `22` (SSH)
- **Local Port**: `8080` (SOCKS proxy)

---

## Security Notes:

✅ **fail2ban** is enabled - automatically blocks brute-force attempts
✅ **Strong password** - 24 characters, cryptographically generated
✅ **Both methods work** - Use password for convenience, SSH key for max security

**⚠️ Keep your password secure!** Save it in your password manager.