#!/bin/bash
# Adiciona um torrent ao Transmission
# Uso: ./torrent-add.sh "magnet:?xt=urn:btih:..."
#      ./torrent-add.sh /caminho/arquivo.torrent

if [ -z "$1" ]; then
    echo "Uso: $0 <magnet-link ou arquivo.torrent>"
    exit 1
fi

TORRENT="$1"

# Verifica se transmission-daemon está rodando
if ! systemctl is-active --quiet transmission-daemon; then
    echo "Erro: transmission-daemon não está rodando"
    echo "Iniciar com: sudo systemctl start transmission-daemon"
    exit 1
fi

# Adiciona o torrent
if [[ "$TORRENT" == magnet:* ]]; then
    # Magnet link
    transmission-remote -a "$TORRENT"
else
    # Arquivo .torrent
    if [ ! -f "$TORRENT" ]; then
        echo "Erro: arquivo não encontrado: $TORRENT"
        exit 1
    fi
    transmission-remote -a "$TORRENT"
fi

echo ""
echo "Status atual:"
transmission-remote -l
