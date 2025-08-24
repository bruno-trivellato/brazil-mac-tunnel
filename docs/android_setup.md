# Android SSH Tunnel Setup 📱🇧🇷

## Method 1: SSH Tunnel App (Easiest)

### Setup:
1. **Install**: "SSH Tunnel" app from Google Play Store
2. **Add Connection**:
   - **Name**: `Brazil Tunnel`
   - **Host**: `74.163.64.57`
   - **Port**: `22`
   - **Username**: `azureuser`
   - **Private Key**: Upload your `id_lila_wordpress_br_rsa` file
   - **Local Port**: `8080`
   - **Tunnel Type**: `SOCKS`

### Usage:
1. **Tap "Brazil Tunnel"** to connect
2. **Enable** in Android WiFi/Network settings:
   - WiFi Settings → Advanced → Proxy → Manual
   - **Host**: `127.0.0.1`
   - **Port**: `8080`

---

## Method 2: Termux (Advanced)

### Setup:
1. **Install Termux** from F-Droid (not Play Store)
2. **Install OpenSSH**: `pkg install openssh`
3. **Copy your SSH key** to Termux storage
4. **Run tunnel**:
   ```bash
   ssh -i ~/.ssh/id_lila_wordpress_br_rsa -D 8080 -C -N -4 azureuser@74.163.64.57
   ```

### Browser Setup:
- **Firefox Mobile**: Install "Proxy Mobile" addon
- **Chrome**: Use system proxy settings above

---

## Method 3: VPN Apps (Alternative)

### If SSH is complex:
- **Outline VPN**: Set up your own VPN server on the Brazil VM
- **WireGuard**: More advanced but very fast

---

## Testing:
1. **Connect tunnel**
2. **Visit**: https://whatismyipaddress.com
3. **Should show**: `74.163.64.57` (Brazil)

## Your SSH Details:
- **Server**: `74.163.64.57`
- **Username**: `azureuser` 
- **Key**: `~/.ssh/id_lila_wordpress_br_rsa`
- **Local Port**: `8080`