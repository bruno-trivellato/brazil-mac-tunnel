#!/bin/bash
# Controle remoto de torrents na VM Brasil
# Usa a mesma configuração do tunnel

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../config.env"

# Carrega configuração
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Erro: config.env não encontrado"
    exit 1
fi

SSH_CMD="ssh -i $SSH_KEY $SSH_USER@$VM_IP"

show_help() {
    echo "Controle Remoto de Torrents - VM Brasil"
    echo ""
    echo "Uso: $0 <comando> [argumentos]"
    echo ""
    echo "Comandos:"
    echo "  add <magnet>    Adicionar torrent (magnet link)"
    echo "  status          Ver status dos downloads"
    echo "  upload [nome]   Upload para Azure Blob (--all para todos)"
    echo "  full <magnet>   Adicionar + monitorar + upload automático"
    echo "  list            Listar arquivos no Azure Blob"
    echo "  link <nome>     Gerar link de download (24h)"
    echo "  delete <nome>   Deletar arquivo do Azure Blob"
    echo "  shell           Abrir shell na VM"
    echo "  setup           Copiar scripts para a VM"
    echo ""
    echo "Exemplos:"
    echo "  $0 add \"magnet:?xt=urn:btih:...\""
    echo "  $0 status"
    echo "  $0 full \"magnet:?xt=urn:btih:...\""
    echo "  $0 link \"arquivo.mkv\""
}

case "$1" in
    add)
        if [ -z "$2" ]; then
            echo "Uso: $0 add <magnet-link>"
            exit 1
        fi
        $SSH_CMD "./torrent-add.sh '$2'"
        ;;
    status)
        $SSH_CMD "./torrent-status.sh"
        ;;
    upload)
        if [ -z "$2" ]; then
            $SSH_CMD "./torrent-upload.sh"
        else
            $SSH_CMD "./torrent-upload.sh '$2'"
        fi
        ;;
    full)
        if [ -z "$2" ]; then
            echo "Uso: $0 full <magnet-link>"
            exit 1
        fi
        ssh -t -i "$SSH_KEY" "$SSH_USER@$VM_IP" "./torrent-full.sh '$2'"
        ;;
    list)
        $SSH_CMD 'source ~/.torrent-env; az storage blob list --container-name downloads --connection-string "$AZURE_STORAGE_CONNECTION_STRING" --query "[].{Name:name, Size:properties.contentLength, Created:properties.creationTime}" -o table'
        ;;
    link)
        if [ -z "$2" ]; then
            echo "Uso: $0 link <nome-do-arquivo>"
            exit 1
        fi
        BLOB_NAME="$2"
        $SSH_CMD "source ~/.torrent-env; EXPIRY=\$(date -u -d '+24 hours' '+%Y-%m-%dT%H:%MZ'); az storage blob generate-sas --container-name downloads --name '$BLOB_NAME' --permissions r --expiry \"\$EXPIRY\" --connection-string \"\$AZURE_STORAGE_CONNECTION_STRING\" --full-uri -o tsv"
        ;;
    delete)
        if [ -z "$2" ]; then
            echo "Uso: $0 delete <nome-do-arquivo>"
            exit 1
        fi
        $SSH_CMD "source ~/.torrent-env; az storage blob delete --container-name downloads --name '$2' --connection-string \"\$AZURE_STORAGE_CONNECTION_STRING\""
        echo "Arquivo deletado: $2"
        ;;
    shell)
        ssh -i "$SSH_KEY" "$SSH_USER@$VM_IP"
        ;;
    setup)
        echo "Copiando scripts para a VM..."
        scp -i "$SSH_KEY" "$SCRIPT_DIR/../vm-scripts/"*.sh "$SSH_USER@$VM_IP:~/"
        $SSH_CMD "chmod +x ~/*.sh"
        echo "Scripts copiados!"
        echo ""
        echo "IMPORTANTE: Configure a connection string na VM:"
        echo "  1. Conecte na VM: $0 shell"
        echo "  2. Adicione ao ~/.bashrc:"
        echo "     export AZURE_STORAGE_CONNECTION_STRING=\"sua-connection-string\""
        echo "  3. Execute: source ~/.bashrc"
        ;;
    *)
        show_help
        ;;
esac
