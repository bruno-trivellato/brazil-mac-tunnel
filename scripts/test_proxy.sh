#!/bin/bash

# Load configuration
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
source "$PROJECT_DIR/config.env"

echo "Testing SSH tunnel proxy..."

# Check if tunnel is running
if pgrep -f "ssh.*${LOCAL_PORT}.*${SSH_USER}@${VM_IP}" > /dev/null; then
    echo "✅ SSH tunnel is running"
    
    # Test the proxy
    echo "Testing proxy connection..."
    RESULT=$(curl --socks5 127.0.0.1:${LOCAL_PORT} -4 --connect-timeout 5 --max-time 10 -s ifconfig.me 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
        echo "✅ Proxy is working!"
        echo "Your IP through tunnel: $RESULT"
        echo "Expected Brazil VM IP: ${VM_IP}"
        
        if [ "$RESULT" = "${VM_IP}" ]; then
            echo "🎉 Perfect! You're tunneling through Brazil!"
        else
            echo "⚠️  IP doesn't match expected Brazil VM IP"
        fi
    else
        echo "❌ Proxy connection failed"
        echo "Try: ./ssh_tunnel.sh (and keep it running in another terminal)"
    fi
else
    echo "❌ SSH tunnel is not running"
    echo "Start it with: ./ssh_tunnel.sh"
fi