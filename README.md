# Brazil SSH Tunnel 🇧🇷

**One-click access to Brazilian YouTube lives and geo-restricted content from anywhere in the world.**

*Just clone the repo and double-click the Brazil flag app - that's it!*

## Motivation

After moving from Brazil to Paris in 2024, I discovered that many Brazilian YouTube channels restrict their live streams to Brazil only. Since I already had an Azure VM running in Brazil, I decided to repurpose it as a secure tunnel to access Brazilian content while maintaining privacy and security.

## What This Does

Creates a secure SSH tunnel (SOCKS5 proxy) from your device to a Brazilian Azure VM, making your internet traffic appear to originate from Brazil. Perfect for:

- 📺 Brazilian YouTube live streams
- 🎵 Geo-restricted music services  
- 🏛️ Brazilian banking and government sites
- 🛡️ Secure browsing while traveling

## 🚀 Super Simple Setup

**Clone and click - that's it!**

1. **Clone this repo**: `git clone [repo-url]`
2. **Double-click**: `🇧🇷 Brazil SSH Tunnel.app` 
3. **Done!** Terminal opens with tunnel management

### Alternative: Command Line

```bash
./tools/start            # Interactive tunnel management
```

### Advanced: Direct Script Access

```bash
./scripts/ssh_tunnel.sh  # Start tunnel directly
./scripts/test_proxy.sh  # Test connection
./scripts/debug_tunnel.sh # Troubleshoot issues
```

## Getting Started from Scratch

### Step 1: Create Azure VM
**Need a Brazilian server?** Follow our guide:
- 📖 **[Azure VM Setup](docs/azure_vm_setup.md)** - Complete Debian 12 VM creation
- 💰 **Cost**: ~$15-20/month for Standard_B1s in Brazil South
- ⏱️ **Time**: 10 minutes

### Step 2: Generate SSH Keys  
**Secure authentication setup:**
- 🔐 **[SSH Key Setup](docs/ssh_key_setup.md)** - Generate and configure keys
- 🛡️ **Security**: 4096-bit RSA keys with Azure integration
- ⏱️ **Time**: 5 minutes

### Step 3: Configure & Launch
**The smart app handles everything else:**
- 🎯 **Auto-detects** missing configuration
- 🧭 **Guides you** through each step
- 🔧 **Tests connections** automatically
- 🚀 **Launches tunnel** when ready

## Manual Configuration

Copy the sample configuration and update with your values:

```bash
cp config.env.sample config.env
```

Then edit `config.env` with your details:

```bash
VM_IP="your.vm.ip.address"        # Your Azure VM public IP
SSH_USER="your_ssh_username"      # SSH username
SSH_KEY="~/.ssh/your_key.rsa"     # Path to your SSH private key
LOCAL_PORT="8080"                 # Local SOCKS proxy port
```

**⚠️ Important**: Never commit your `config.env` file with real credentials to Git!

## Tools & Setup

### 🖥️ **macOS** 
- **SSH Tunnel**: Native SSH client with SOCKS5 proxy
- **FoxyProxy**: Firefox extension for easy proxy toggling
- **macOS App**: One-click tunnel launcher in Dock

### 📱 **Android**
- **SSH Tunnel App**: Google Play Store app for mobile tunneling
- **System Proxy**: Android WiFi proxy configuration

### 🌐 **Browser Integration**
- **Firefox**: FoxyProxy extension with visual toggle
- **Chrome**: Manual proxy settings or extensions

## Project Structure

```
brazil-ssh-tunnel/
├── 🇧🇷 Brazil SSH Tunnel.app   # 🎯 Main entry point (just double-click!)
├── config.env.sample            # Configuration template (copy to config.env)
├── scripts/
│   ├── ssh_tunnel.sh            # Main tunnel script
│   ├── test_proxy.sh            # Connection tester
│   └── debug_tunnel.sh          # Troubleshooting tool
├── docs/
│   ├── azure_vm_setup.md        # Azure VM creation guide
│   ├── ssh_key_setup.md         # SSH key generation guide
│   ├── foxyproxy_setup.md       # Browser setup guide
│   ├── android_setup.md         # Mobile setup guide
│   └── icon_setup.md            # App icon setup guide
└── tools/
    ├── start                     # Interactive tunnel management
    ├── create_smart_app.sh       # Generate macOS app
    └── *.sh                      # Other utilities
```

**Clone → Click → Connect**: The Brazil flag app is your main entry point! 🇧🇷

## Technical Details

- **Protocol**: SSH with dynamic port forwarding (-D flag)
- **Proxy Type**: SOCKS5 on localhost
- **Security**: SSH key authentication, no passwords
- **Performance**: Compression enabled (-C flag)
- **Reliability**: Keep-alive packets every 30 seconds

## Azure VM Requirements

- **Location**: Brazil (São Paulo region recommended)
- **OS**: Any Linux distribution with SSH
- **Network**: Public IP with SSH port 22 open
- **Authentication**: SSH key pairs (no password auth)

## Test Your Connection

Visit [whatismyipaddress.com](https://whatismyipaddress.com) - should show your Brazilian VM IP 🇧🇷

---

*Made with ❤️ for Brazilians living abroad*