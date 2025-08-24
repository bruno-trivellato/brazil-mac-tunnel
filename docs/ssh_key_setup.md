# SSH Key Setup Guide 🔐

Step-by-step guide to generate and configure SSH keys for your Brazil tunnel.

## Why SSH Keys?

- 🔒 **More secure** than passwords
- 🚫 **No password typing** required  
- 🤖 **Works with automation** and scripts

## Step 1: Generate SSH Key Pair

### Option A: Generate New Key (Recommended)

```bash
# Generate new key specifically for Brazil VM
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_lila_wordpress_br_rsa -C "brazil-tunnel-$(whoami)"
```

**What this does:**
- `-t rsa -b 4096`: Creates strong 4096-bit RSA key
- `-f ~/.ssh/id_lila_wordpress_br_rsa`: Names the key file
- `-C "comment"`: Adds identifying comment

**You'll be prompted:**
```
Enter passphrase (empty for no passphrase): [Press ENTER]
Enter same passphrase again: [Press ENTER]
```

💡 **Tip**: Empty passphrase = no typing needed later

### Option B: Use Existing Key

If you already have SSH keys:
```bash
# List existing keys
ls -la ~/.ssh/

# Use existing key (rename if needed)
cp ~/.ssh/id_rsa ~/.ssh/id_lila_wordpress_br_rsa
cp ~/.ssh/id_rsa.pub ~/.ssh/id_lila_wordpress_br_rsa.pub
```

## Step 2: Verify Key Generation

```bash
# Check private key exists
ls -la ~/.ssh/id_lila_wordpress_br_rsa

# Check public key exists  
ls -la ~/.ssh/id_lila_wordpress_br_rsa.pub

# View public key content
cat ~/.ssh/id_lila_wordpress_br_rsa.pub
```

Should show something like:
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7... brazil-tunnel-bruno
```

## Step 3: Set Correct Permissions

```bash
# Private key: readable only by you
chmod 600 ~/.ssh/id_lila_wordpress_br_rsa

# Public key: readable by everyone  
chmod 644 ~/.ssh/id_lila_wordpress_br_rsa.pub

# SSH directory
chmod 700 ~/.ssh/
```

## Step 4: Add Public Key to Azure VM

### Method A: During VM Creation (Automatic)
If you used `--generate-ssh-keys` during VM creation, Azure already has your key.

### Method B: Add to Existing VM
```bash
az vm user update \
  --resource-group LILA_PRODUCTION \
  --name lila-worpress-br \
  --username azureuser \
  --ssh-key-value ~/.ssh/id_lila_wordpress_br_rsa.pub
```

### Method C: Manual Upload
1. Copy public key content: `cat ~/.ssh/id_lila_wordpress_br_rsa.pub`
2. Azure Portal → Your VM → Settings → Reset password
3. Mode: "Reset SSH public key"
4. Username: `azureuser`
5. Paste public key content

## Step 5: Test SSH Connection

```bash
# Test connection (replace with your VM IP)
ssh -i ~/.ssh/id_lila_wordpress_br_rsa azureuser@74.163.64.57

# If successful, you'll see:
azureuser@lila-worpress-br:~$ 
```

## Troubleshooting

### "Permission denied (publickey)"
```bash
# Check key permissions
ls -la ~/.ssh/id_lila_wordpress_br_rsa
# Should show: -rw-------

# Fix permissions if needed
chmod 600 ~/.ssh/id_lila_wordpress_br_rsa
```

### "Host key verification failed"
```bash
# Add host to known hosts
ssh-keyscan -H YOUR_VM_IP >> ~/.ssh/known_hosts

# Or connect with verification disabled (less secure)
ssh -i ~/.ssh/id_lila_wordpress_br_rsa -o StrictHostKeyChecking=no azureuser@YOUR_VM_IP
```

### Key not found
```bash
# Verify key exists
ls -la ~/.ssh/id_lila_wordpress_br_rsa*

# Regenerate if missing
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_lila_wordpress_br_rsa
```

## Advanced: SSH Config

Create `~/.ssh/config` for easier connections:

```bash
# Add this to ~/.ssh/config
Host brazil-vm
    HostName 74.163.64.57
    User azureuser
    IdentityFile ~/.ssh/id_lila_wordpress_br_rsa
    ServerAliveInterval 30
```

Then connect with just: `ssh brazil-vm`

---

✅ **Next:** Set up macOS app → [Icon Setup Guide](icon_setup.md)