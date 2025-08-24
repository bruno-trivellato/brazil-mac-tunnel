#!/bin/bash

# SSH Tunnel to Debian VM in Brazil for secure browsing
# This creates a SOCKS proxy on local port specified in config

# Load configuration
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
source "$PROJECT_DIR/config.env"

# Expand tilde in SSH_KEY path
SSH_KEY="${SSH_KEY/#\~/$HOME}"

echo "Creating ${TUNNEL_NAME}..."
echo "SOCKS proxy will be available on localhost:${LOCAL_PORT}"
echo "Press Ctrl+C to stop the tunnel"

ssh -i "${SSH_KEY}" \
    -D ${LOCAL_PORT} \
    ${SSH_OPTIONS} \
    ${SSH_USER}@${VM_IP}