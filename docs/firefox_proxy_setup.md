# Firefox SOCKS Proxy Configuration

## Steps to configure Firefox to use your SSH tunnel:

1. Open Firefox
2. Go to **Firefox Preferences** (Firefox → Preferences or Cmd+,)
3. Scroll down to **Network Settings** section
4. Click **Settings...** button
5. Select **Manual proxy configuration**
6. Fill in the following:
   - **SOCKS Host:** `127.0.0.1`
   - **Port:** `8080`
   - Select **SOCKS v5**
7. Check **Proxy DNS when using SOCKS v5**
8. Click **OK** to save

## Quick test:
1. Start the tunnel: `./ssh_tunnel.sh`
2. In Firefox, visit: https://whatismyipaddress.com
3. You should see your Brazil VM's IP: `74.163.64.57`

## To disable proxy:
Go back to Network Settings and select **No proxy**