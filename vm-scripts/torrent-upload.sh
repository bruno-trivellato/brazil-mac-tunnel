#!/bin/bash
# Upload de arquivos baixados para Azure Blob Storage
# Uso: ./torrent-upload.sh "Nome do Arquivo"
#      ./torrent-upload.sh --all

# Carrega variáveis de ambiente
[ -f ~/.torrent-env ] && source ~/.torrent-env

DOWNLOADS_DIR="$HOME/downloads"
CONTAINER="downloads"

# Verifica se Azure CLI está configurado
if [ -z "$AZURE_STORAGE_CONNECTION_STRING" ]; then
    echo "Erro: AZURE_STORAGE_CONNECTION_STRING não configurada"
    echo "Adicione ao ~/.bashrc:"
    echo 'export AZURE_STORAGE_CONNECTION_STRING="sua-connection-string"'
    exit 1
fi

upload_file() {
    local file="$1"
    local basename=$(basename "$file")

    echo "Uploading: $basename"
    echo ""

    az storage blob upload \
        --container-name "$CONTAINER" \
        --file "$file" \
        --name "$basename" \
        --connection-string "$AZURE_STORAGE_CONNECTION_STRING" \
        --overwrite \
        --output none

    if [ $? -eq 0 ]; then
        echo "Upload completo: $basename"

        # Gerar link SAS válido por 24h
        EXPIRY=$(date -u -d "+24 hours" '+%Y-%m-%dT%H:%MZ' 2>/dev/null || date -u -v+24H '+%Y-%m-%dT%H:%MZ')

        SAS_URL=$(az storage blob generate-sas \
            --container-name "$CONTAINER" \
            --name "$basename" \
            --permissions r \
            --expiry "$EXPIRY" \
            --connection-string "$AZURE_STORAGE_CONNECTION_STRING" \
            --full-uri \
            --output tsv)

        echo ""
        echo "Link de download (válido por 24h):"
        echo "$SAS_URL"
    else
        echo "Erro no upload de: $basename"
        return 1
    fi
}

if [ "$1" == "--all" ]; then
    echo "=== Upload de todos os arquivos completos ==="
    echo ""

    for file in "$DOWNLOADS_DIR"/*; do
        if [ -e "$file" ] && [[ "$(basename "$file")" != ".incomplete" ]] && [ ! -d "$file" ]; then
            upload_file "$file"
            echo ""
            echo "---"
            echo ""
        elif [ -d "$file" ] && [[ "$(basename "$file")" != ".incomplete" ]]; then
            # Para diretórios, compactar primeiro
            dirname=$(basename "$file")
            echo "Compactando diretório: $dirname"
            tar -czf "$DOWNLOADS_DIR/$dirname.tar.gz" -C "$DOWNLOADS_DIR" "$dirname"
            upload_file "$DOWNLOADS_DIR/$dirname.tar.gz"
            rm "$DOWNLOADS_DIR/$dirname.tar.gz"
            echo ""
            echo "---"
            echo ""
        fi
    done

    echo "Todos os uploads concluídos!"

elif [ -n "$1" ]; then
    FILE="$1"

    if [[ "$FILE" != /* ]]; then
        FOUND=$(find "$DOWNLOADS_DIR" -maxdepth 1 -name "*$FILE*" -not -name ".incomplete" | head -1)
        if [ -n "$FOUND" ]; then
            FILE="$FOUND"
        else
            echo "Arquivo não encontrado: $FILE"
            echo ""
            echo "Arquivos disponíveis:"
            ls -1 "$DOWNLOADS_DIR" 2>/dev/null | grep -v ".incomplete"
            exit 1
        fi
    fi

    if [ -d "$FILE" ]; then
        dirname=$(basename "$FILE")
        echo "Compactando diretório: $dirname"
        tar -czf "$DOWNLOADS_DIR/$dirname.tar.gz" -C "$DOWNLOADS_DIR" "$dirname"
        upload_file "$DOWNLOADS_DIR/$dirname.tar.gz"
        rm "$DOWNLOADS_DIR/$dirname.tar.gz"
    else
        upload_file "$FILE"
    fi

else
    echo "Uso: $0 <nome-do-arquivo>"
    echo "      $0 --all"
    echo ""
    echo "Arquivos disponíveis em $DOWNLOADS_DIR:"
    ls -lh "$DOWNLOADS_DIR" 2>/dev/null | grep -v "^total" | grep -v ".incomplete"
fi
