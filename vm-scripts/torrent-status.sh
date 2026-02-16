#!/bin/bash
# Mostra status dos torrents no Transmission

# Verifica se transmission-daemon está rodando
if ! systemctl is-active --quiet transmission-daemon; then
    echo "Erro: transmission-daemon não está rodando"
    echo "Iniciar com: sudo systemctl start transmission-daemon"
    exit 1
fi

echo "=== Status dos Torrents ==="
echo ""
transmission-remote -l

echo ""
echo "=== Espaço em disco ==="
df -h /home/azureuser/downloads 2>/dev/null || df -h ~

echo ""
echo "=== Arquivos completos ==="
ls -lh ~/downloads/ 2>/dev/null | grep -v "^total" | grep -v ".incomplete"
