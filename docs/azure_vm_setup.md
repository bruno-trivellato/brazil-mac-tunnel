# Azure VM Setup Guide 🇧🇷☁️

Complete guide to setting up your Brazilian Azure VM for SSH tunneling.

## Prerequisites

- Azure account with active subscription
- Azure CLI installed: `brew install azure-cli` (macOS) or [download](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## Step 1: Login to Azure

```bash
az login
```

This opens your browser for authentication.

## Step 2: Create Resource Group

```bash
az group create \
  --name LILA_PRODUCTION \
  --location brazilsouth
```

## Step 3: Create the VM

```bash
az vm create \
  --resource-group LILA_PRODUCTION \
  --name lila-worpress-br \
  --image Debian11 \
  --size Standard_B1s \
  --location brazilsouth \
  --admin-username azureuser \
  --generate-ssh-keys \
  --public-ip-sku Standard
```

**Options explained:**
- `--image Debian11`: Latest Debian (we're using Debian 12 in production)
- `--size Standard_B1s`: Small/cheap VM (perfect for tunneling)
- `--location brazilsouth`: São Paulo region
- `--generate-ssh-keys`: Creates SSH keys automatically

## Step 4: Update to Debian 12 (Optional)

SSH into your VM and upgrade:

```bash
# SSH into the VM (get IP from Azure portal)
ssh azureuser@<YOUR_VM_IP>

# Update to Debian 12
sudo sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list
sudo apt update && sudo apt full-upgrade -y
sudo reboot
```

## Step 5: Configure SSH Access

Add your public SSH key (if you have your own):

```bash
az vm user update \
  --resource-group LILA_PRODUCTION \
  --name lila-worpress-br \
  --username azureuser \
  --ssh-key-value ~/.ssh/id_lila_wordpress_br_rsa.pub
```

## Step 6: Get VM Public IP

```bash
az vm show \
  --resource-group LILA_PRODUCTION \
  --name lila-worpress-br \
  --show-details \
  --query publicIps \
  --output tsv
```

## Step 7: Test SSH Connection

```bash
ssh -i ~/.ssh/id_lila_wordpress_br_rsa azureuser@<YOUR_VM_IP>
```

## Security Configuration

### Open SSH Port (if needed)
```bash
az network nsg rule create \
  --resource-group LILA_PRODUCTION \
  --nsg-name lila-worpress-brNSG \
  --name SSH \
  --protocol tcp \
  --priority 1000 \
  --destination-port-range 22 \
  --access allow
```

### Check SSH Configuration on VM
```bash
sudo grep -E '(AllowTcpForwarding|PasswordAuthentication)' /etc/ssh/sshd_config
```

Should show:
- `AllowTcpForwarding yes` (or commented out = default yes)
- `PasswordAuthentication no` (key-only auth)

## Costs 💰

**Standard_B1s in Brazil South:**
- ~$15-20 USD/month
- 1 vCPU, 1 GB RAM, 4 GB SSD
- Perfect for SSH tunneling

## Troubleshooting

**Can't connect?**
1. Check VM is running: `az vm get-instance-view --resource-group LILA_PRODUCTION --name lila-worpress-br`
2. Verify NSG rules allow SSH (port 22)
3. Check your SSH key permissions: `chmod 600 ~/.ssh/id_lila_wordpress_br_rsa`

**VM stopped?**
```bash
az vm start --resource-group LILA_PRODUCTION --name lila-worpress-br
```

**Delete VM (careful!):**
```bash
az group delete --name LILA_PRODUCTION --yes --no-wait
```

---

✅ **Next:** Generate SSH keys → [SSH Key Setup Guide](ssh_key_setup.md)