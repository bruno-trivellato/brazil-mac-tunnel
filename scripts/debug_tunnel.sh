#!/bin/bash

# Load configuration
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
source "$PROJECT_DIR/config.env"

# Expand tilde in SSH_KEY path
SSH_KEY="${SSH_KEY/#\~/$HOME}"

echo "🔍 SSH Tunnel Debug Script"
echo "=========================="

# Check SSH key exists
echo "1. Checking SSH key..."
if [ -f "${SSH_KEY}" ]; then
    echo "✅ SSH key exists"
    ls -la "${SSH_KEY}"
else
    echo "❌ SSH key not found at ${SSH_KEY}"
fi

# Check SSH key permissions
echo -e "\n2. Checking SSH key permissions..."
PERMS=$(stat -f "%A" "${SSH_KEY}" 2>/dev/null)
if [ "$PERMS" = "600" ]; then
    echo "✅ SSH key permissions correct (600)"
else
    echo "⚠️  SSH key permissions: $PERMS (should be 600)"
    echo "Fix with: chmod 600 ${SSH_KEY}"
fi

# Test basic SSH connection
echo -e "\n3. Testing basic SSH connection..."
ssh -i "${SSH_KEY}" -o ConnectTimeout=5 -o BatchMode=yes ${SSH_USER}@${VM_IP} "echo 'SSH works'" 2>&1

# Check if port is in use
echo -e "\n4. Checking if port ${LOCAL_PORT} is in use..."
if lsof -i :${LOCAL_PORT} > /dev/null 2>&1; then
    echo "⚠️  Port ${LOCAL_PORT} is in use:"
    lsof -i :${LOCAL_PORT}
else
    echo "✅ Port ${LOCAL_PORT} is available"
fi

# Check running SSH tunnels
echo -e "\n5. Checking for existing SSH tunnels..."
TUNNELS=$(ps aux | grep "ssh.*${LOCAL_PORT}" | grep -v grep)
if [ -n "$TUNNELS" ]; then
    echo "Found SSH tunnels:"
    echo "$TUNNELS"
else
    echo "❌ No SSH tunnels found"
fi

# Test tunnel creation with verbose output
echo -e "\n6. Testing tunnel creation (verbose)..."
echo "Command: ssh -i ${SSH_KEY} -D ${LOCAL_PORT} -v -N ${SSH_USER}@${VM_IP}"
echo "Starting tunnel for 10 seconds..."

# Use sleep instead of timeout (not available on macOS by default)
ssh -i "${SSH_KEY}" -D ${LOCAL_PORT} -v -N ${SSH_USER}@${VM_IP} &
TUNNEL_PID=$!

# Wait a moment then test
sleep 3

echo -e "\n7. Testing SOCKS proxy while tunnel is running..."
curl --socks5 localhost:${LOCAL_PORT} --connect-timeout 3 --max-time 5 -v ifconfig.me 2>&1

# Clean up
kill $TUNNEL_PID 2>/dev/null
wait $TUNNEL_PID 2>/dev/null

echo -e "\n8. Network connectivity test..."
echo "Testing direct connection to ifconfig.me:"
curl --connect-timeout 5 --max-time 5 ifconfig.me 2>/dev/null
echo ""

echo -e "\nDebug complete! 🔍"