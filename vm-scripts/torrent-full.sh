#!/bin/bash
# Script completo: adiciona torrent, monitora e faz upload quando terminar
# Uso: ./torrent-full.sh "magnet:?xt=urn:btih:..."

# Carrega variáveis de ambiente
[ -f ~/.torrent-env ] && source ~/.torrent-env

if [ -z "$1" ]; then
    echo "Uso: $0 <magnet-link ou arquivo.torrent>"
    exit 1
fi

TORRENT="$1"
DOWNLOADS_DIR="$HOME/downloads"
CONTAINER="downloads"

echo "=== Torrent + Upload Automático ==="
echo ""

# Verifica dependências
if ! systemctl is-active --quiet transmission-daemon; then
    echo "Erro: transmission-daemon não está rodando"
    exit 1
fi

if [ -z "$AZURE_STORAGE_CONNECTION_STRING" ]; then
    echo "Erro: AZURE_STORAGE_CONNECTION_STRING não configurada"
    exit 1
fi

# Pega lista de arquivos antes de adicionar
FILES_BEFORE=$(ls -1 "$DOWNLOADS_DIR" 2>/dev/null | grep -v ".incomplete")

# Adiciona o torrent
echo "Adicionando torrent..."
transmission-remote -a "$TORRENT"

# Pega o ID do torrent adicionado (último da lista)
sleep 2
TORRENT_ID=$(transmission-remote -l | tail -2 | head -1 | awk '{print $1}')
TORRENT_NAME=$(transmission-remote -t "$TORRENT_ID" -i 2>/dev/null | grep "Name:" | cut -d: -f2- | xargs)

echo "Torrent ID: $TORRENT_ID"
echo "Nome: $TORRENT_NAME"
echo ""
echo "Monitorando download... (Ctrl+C para cancelar monitoramento)"
echo ""

# Monitora até completar
while true; do
    INFO=$(transmission-remote -t "$TORRENT_ID" -i 2>/dev/null)

    if [ -z "$INFO" ]; then
        echo "Torrent não encontrado (pode ter sido removido)"
        exit 1
    fi

    PERCENT=$(echo "$INFO" | grep "Percent Done:" | awk '{print $3}')
    STATE=$(echo "$INFO" | grep "State:" | cut -d: -f2- | xargs)
    ETA=$(echo "$INFO" | grep "ETA:" | cut -d: -f2- | xargs)

    printf "\r%-80s" " "
    printf "\r[%s] %s - ETA: %s" "$PERCENT" "$STATE" "$ETA"

    if [ "$PERCENT" == "100%" ] || [ "$STATE" == "Finished" ] || [ "$STATE" == "Seeding" ]; then
        echo ""
        echo ""
        echo "Download completo!"
        break
    fi

    sleep 5
done

# Encontra o arquivo novo
echo ""
echo "Procurando arquivo baixado..."
sleep 2

FILES_AFTER=$(ls -1 "$DOWNLOADS_DIR" 2>/dev/null | grep -v ".incomplete")
NEW_FILE=$(comm -13 <(echo "$FILES_BEFORE" | sort) <(echo "$FILES_AFTER" | sort) | head -1)

if [ -z "$NEW_FILE" ]; then
    NEW_FILE=$(ls -1 "$DOWNLOADS_DIR" 2>/dev/null | grep -v ".incomplete" | grep -i "$(echo "$TORRENT_NAME" | cut -c1-20)" | head -1)
fi

if [ -z "$NEW_FILE" ]; then
    echo "Não consegui identificar o arquivo baixado automaticamente."
    echo ""
    echo "Arquivos em $DOWNLOADS_DIR:"
    ls -lh "$DOWNLOADS_DIR" | grep -v ".incomplete"
    echo ""
    echo "Execute manualmente: ./torrent-upload.sh 'nome-do-arquivo'"
    exit 1
fi

FULL_PATH="$DOWNLOADS_DIR/$NEW_FILE"
echo "Arquivo encontrado: $NEW_FILE"
echo ""

# Upload pro Azure Blob
echo "=== Iniciando upload para Azure Blob ==="
echo ""

# Se for diretório, compacta
if [ -d "$FULL_PATH" ]; then
    echo "Compactando diretório..."
    tar -czf "$DOWNLOADS_DIR/$NEW_FILE.tar.gz" -C "$DOWNLOADS_DIR" "$NEW_FILE"
    UPLOAD_FILE="$DOWNLOADS_DIR/$NEW_FILE.tar.gz"
    BLOB_NAME="$NEW_FILE.tar.gz"
else
    UPLOAD_FILE="$FULL_PATH"
    BLOB_NAME="$NEW_FILE"
fi

az storage blob upload \
    --container-name "$CONTAINER" \
    --file "$UPLOAD_FILE" \
    --name "$BLOB_NAME" \
    --connection-string "$AZURE_STORAGE_CONNECTION_STRING" \
    --overwrite \
    --output none

if [ $? -eq 0 ]; then
    # Gerar link SAS válido por 24h
    EXPIRY=$(date -u -d "+24 hours" '+%Y-%m-%dT%H:%MZ' 2>/dev/null || date -u -v+24H '+%Y-%m-%dT%H:%MZ')

    SAS_URL=$(az storage blob generate-sas \
        --container-name "$CONTAINER" \
        --name "$BLOB_NAME" \
        --permissions r \
        --expiry "$EXPIRY" \
        --connection-string "$AZURE_STORAGE_CONNECTION_STRING" \
        --full-uri \
        --output tsv)

    echo ""
    echo "=========================================="
    echo "CONCLUÍDO!"
    echo "Arquivo: $BLOB_NAME"
    echo ""
    echo "Link de download (válido por 24h):"
    echo "$SAS_URL"
    echo "=========================================="

    # Limpa arquivo temporário se foi compactado
    if [ -d "$FULL_PATH" ]; then
        rm "$UPLOAD_FILE"
    fi

    # Pergunta se quer deletar local
    echo ""
    read -p "Deletar arquivo local e torrent? [s/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        rm -rf "$FULL_PATH"
        transmission-remote -t "$TORRENT_ID" -r
        echo "Arquivo local e torrent removidos."
    fi
else
    echo ""
    echo "Erro no upload! Arquivo mantido em: $FULL_PATH"
    exit 1
fi
