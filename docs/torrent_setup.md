# Sistema de Torrent + OneDrive na VM Brasil

Este guia configura um sistema para:
1. Baixar torrents na VM do Brasil
2. Fazer upload automático pro OneDrive

## 1. Conectar na VM

```bash
ssh -i ~/.ssh/id_lila_wordpress_br_rsa azureuser@74.163.64.57
```

## 2. Instalar Transmission

```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar transmission-daemon
sudo apt install -y transmission-daemon

# Parar o serviço pra editar config
sudo systemctl stop transmission-daemon
```

## 3. Configurar Transmission

Editar a configuração:

```bash
sudo nano /etc/transmission-daemon/settings.json
```

Alterar estas linhas:

```json
{
    "download-dir": "/home/azureuser/downloads",
    "incomplete-dir": "/home/azureuser/downloads/.incomplete",
    "incomplete-dir-enabled": true,
    "rpc-authentication-required": false,
    "rpc-bind-address": "127.0.0.1",
    "rpc-enabled": true,
    "rpc-port": 9091,
    "rpc-whitelist-enabled": false,
    "umask": 2
}
```

Criar diretórios e ajustar permissões:

```bash
mkdir -p ~/downloads/.incomplete
sudo chown -R debian-transmission:debian-transmission ~/downloads
sudo usermod -a -G debian-transmission azureuser
chmod 775 ~/downloads
```

Iniciar o serviço:

```bash
sudo systemctl start transmission-daemon
sudo systemctl enable transmission-daemon
```

## 4. Instalar rclone

```bash
# Instalar rclone
curl https://rclone.org/install.sh | sudo bash

# Configurar OneDrive (vai precisar de um navegador)
rclone config
```

### Configuração do OneDrive no rclone

1. `n` (new remote)
2. Nome: `onedrive`
3. Storage type: `onedrive` (número correspondente, geralmente 31)
4. client_id: (deixar em branco, pressionar Enter)
5. client_secret: (deixar em branco, pressionar Enter)
6. region: `global` (opção 1)
7. Edit advanced config? `n`
8. Use auto config? `n` (importante! estamos em servidor sem GUI)
9. Vai mostrar um link - copiar e abrir no seu navegador local
10. Autorizar no navegador e copiar o código de volta pro terminal
11. Account type: `onedrive` (opção 1 - personal)
12. Escolher o drive (geralmente só tem 1)
13. Confirmar com `y`

Testar conexão:

```bash
rclone lsd onedrive:
```

## 5. Copiar os scripts

Os scripts estão em `brazil-mac-tunnel/vm-scripts/`. Copie para a VM:

```bash
# Do seu Mac, na pasta do projeto:
scp -i ~/.ssh/id_lila_wordpress_br_rsa vm-scripts/*.sh azureuser@74.163.64.57:~/
```

Na VM, dar permissão de execução:

```bash
chmod +x ~/*.sh
```

## 6. Uso

### Adicionar torrent (magnet link ou arquivo .torrent)

```bash
# Magnet link
./torrent-add.sh "magnet:?xt=urn:btih:..."

# Arquivo .torrent (precisa estar na VM)
./torrent-add.sh /caminho/arquivo.torrent
```

### Ver status dos downloads

```bash
./torrent-status.sh
```

### Upload pro OneDrive

```bash
# Upload de um arquivo específico
./torrent-upload.sh "Nome do Arquivo"

# Upload de tudo que está completo
./torrent-upload.sh --all
```

### Adicionar e monitorar até completar + upload automático

```bash
./torrent-full.sh "magnet:?xt=urn:btih:..."
```

## 7. Atalhos do Mac

Do Mac, você pode usar estes comandos rápidos:

```bash
# Alias pra adicionar no seu ~/.zshrc ou ~/.bashrc
alias br-torrent='ssh -i ~/.ssh/id_lila_wordpress_br_rsa azureuser@74.163.64.57 "./torrent-add.sh"'
alias br-status='ssh -i ~/.ssh/id_lila_wordpress_br_rsa azureuser@74.163.64.57 "./torrent-status.sh"'
alias br-upload='ssh -i ~/.ssh/id_lila_wordpress_br_rsa azureuser@74.163.64.57 "./torrent-upload.sh"'
```

Uso:
```bash
br-torrent "magnet:?xt=urn:btih:..."
br-status
br-upload --all
```

## Troubleshooting

### Transmission não inicia
```bash
sudo systemctl status transmission-daemon
journalctl -u transmission-daemon -n 50
```

### rclone não conecta
```bash
rclone config reconnect onedrive:
```

### Espaço em disco
```bash
df -h
# Limpar downloads antigos
rm -rf ~/downloads/*
```
