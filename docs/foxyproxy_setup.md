# FoxyProxy Setup for Brazil SSH Tunnel

## Step 1: Install FoxyProxy
1. Open Firefox
2. Go to: https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/
3. Click "Add to Firefox"
4. Click "Add" when prompted
5. You'll see the FoxyProxy icon in your toolbar (fox head icon)

## Step 2: Configure Your Brazil Proxy
1. Click the **FoxyProxy icon** in toolbar
2. Select **"Options"**
3. Click **"Add"** button (+ icon)
4. Fill in these details:
   - **Title:** `Brazil SSH Tunnel`
   - **Proxy Type:** `SOCKS5`
   - **Proxy IP address:** `127.0.0.1`
   - **Port:** `8080`
   - **Username/Password:** Leave blank
5. Click **"Save"**

## Step 3: Usage
- Click the **FoxyProxy icon** in toolbar
- Select options:
  - **"Disable"** = No proxy (direct connection)
  - **"Brazil SSH Tunnel"** = Use your tunnel
  - **"Use proxies based on their pre-defined patterns and priorities"** = Auto mode

## Visual Indicators:
- **Gray icon** = No proxy
- **Colored icon** = Proxy active
- **Icon shows proxy name** on hover

## Quick Test:
1. Start tunnel: `./ssh_tunnel.sh`
2. Click FoxyProxy icon → select "Brazil SSH Tunnel"
3. Visit: https://whatismyipaddress.com
4. Should show: `74.163.64.57` (Brazil)