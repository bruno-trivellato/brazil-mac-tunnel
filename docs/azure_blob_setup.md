# Azure Blob Storage para Torrents

Sistema seguro para transferir arquivos da VM Brasil para seu Mac usando Azure Blob Storage com links temporários.

**Status: CONFIGURADO E FUNCIONANDO**

- Storage Account: `lilatorrentstemp`
- Resource Group: `Bruno-outros`
- Location: Brazil South
- Container: `downloads`
- Auto-delete: 1 dia

## Uso Rápido

```bash
# Do Mac, na pasta do projeto:

# Adicionar torrent + monitorar + upload automático
./scripts/torrent-remote.sh full "magnet:?xt=urn:btih:..."

# Ver status dos downloads
./scripts/torrent-remote.sh status

# Upload manual
./scripts/torrent-remote.sh upload --all

# Listar arquivos no blob
./scripts/torrent-remote.sh list

# Gerar link de download (24h)
./scripts/torrent-remote.sh link "arquivo.mkv"

# Deletar do blob
./scripts/torrent-remote.sh delete "arquivo.mkv"
```

---

## Setup (JÁ FEITO)

## 1. Criar Storage Account (do Mac ou Portal)

### Opção A: Via Azure CLI (recomendado)

```bash
# Instalar Azure CLI se não tiver
brew install azure-cli

# Login no Azure
az login

# Criar Storage Account (mesmo resource group da VM)
az storage account create \
    --name "lilatorrentstemp" \
    --resource-group "LILA_PRODUCTION" \
    --location "brazilsouth" \
    --sku "Standard_LRS" \
    --kind "StorageV2"

# Criar container
az storage container create \
    --name "downloads" \
    --account-name "lilatorrentstemp"

# Pegar connection string (guardar isso!)
az storage account show-connection-string \
    --name "lilatorrentstemp" \
    --resource-group "LILA_PRODUCTION" \
    --query connectionString -o tsv
```

### Opção B: Via Portal Azure

1. Portal Azure → Storage Accounts → Create
2. Resource group: `LILA_PRODUCTION`
3. Name: `lilatorrentstemp` (ou outro nome único)
4. Region: `Brazil South`
5. Performance: Standard
6. Redundancy: LRS (mais barato)
7. Create → Esperar criar
8. Ir em Containers → + Container → Nome: `downloads`
9. Ir em Access keys → Copiar Connection string

## 2. Configurar Lifecycle (auto-delete após 7 dias)

```bash
# Criar política de lifecycle
az storage account management-policy create \
    --account-name "lilatorrentstemp" \
    --resource-group "LILA_PRODUCTION" \
    --policy '{
        "rules": [{
            "enabled": true,
            "name": "auto-delete-after-7-days",
            "type": "Lifecycle",
            "definition": {
                "filters": {
                    "blobTypes": ["blockBlob"],
                    "prefixMatch": ["downloads/"]
                },
                "actions": {
                    "baseBlob": {
                        "delete": {"daysAfterCreationGreaterThan": 7}
                    }
                }
            }
        }]
    }'
```

Ou pelo portal: Storage Account → Lifecycle management → Add rule

## 3. Configurar a VM

```bash
# Conectar na VM
ssh -i ~/.ssh/id_lila_wordpress_br_rsa azureuser@74.163.64.57

# Instalar Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Salvar connection string (SUBSTITUA pela sua!)
echo 'export AZURE_STORAGE_CONNECTION_STRING="DefaultEndpointsProtocol=https;AccountName=lilatorrentstemp;AccountKey=SUA_CHAVE_AQUI;EndpointSuffix=core.windows.net"' >> ~/.bashrc
source ~/.bashrc
```

## 4. Copiar scripts atualizados

Do Mac:
```bash
./scripts/torrent-remote.sh setup
```

## 5. Uso

### Adicionar torrent e fazer upload
```bash
./scripts/torrent-remote.sh full "magnet:?xt=urn:btih:..."
```

### Ver status
```bash
./scripts/torrent-remote.sh status
```

### Upload manual
```bash
./scripts/torrent-remote.sh upload "nome-do-arquivo"
```

### Listar arquivos no blob
```bash
./scripts/torrent-remote.sh list
```

### Gerar link de download (válido por 24h)
```bash
./scripts/torrent-remote.sh link "nome-do-arquivo"
```

### Deletar arquivo do blob
```bash
./scripts/torrent-remote.sh delete "nome-do-arquivo"
```

## Custos estimados

- Storage Account LRS Brazil South: ~$0.02/GB/mês
- Transferência de saída: ~$0.08/GB (download pro Mac)
- Para 50GB/mês: ~$5

## Segurança

- Connection string fica só na VM (não no seu Mac)
- Links SAS expiram em 24h (configurável)
- Arquivos auto-deletam em 7 dias
- Ninguém mais tem acesso ao container

## Troubleshooting

### Erro de autenticação
```bash
# Verificar se connection string está configurada
echo $AZURE_STORAGE_CONNECTION_STRING

# Testar conexão
az storage container list --connection-string "$AZURE_STORAGE_CONNECTION_STRING"
```

### Arquivo não encontrado
```bash
# Listar arquivos no blob
az storage blob list --container-name downloads --connection-string "$AZURE_STORAGE_CONNECTION_STRING" -o table
```
